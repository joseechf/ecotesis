import 'reglas.dart';
import '../llamadasLocales/llamadasFlora.dart';
import '../llamadasRemotas/llamadasFlora.dart';
import '../../data/models/especie_db.dart';
import '../../data/mappers/especie_mapper.dart';
import '../llamadasLocales/sqliteHelper.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class FilasPorSincronizar {
  final List<String> insertToLocal = [], updateToLocal = [], deleteToLocal = [];
  final List<String> insertToRemote = [],
      updateToRemote = [],
      deleteToRemote = [];
  final List<String> discardedLocal = [];
  void clear() {
    insertToLocal.clear();
    updateToLocal.clear();
    deleteToLocal.clear();
    insertToRemote.clear();
    updateToRemote.clear();
    deleteToRemote.clear();
    discardedLocal.clear();
  }
}

class ComparadorFilas {
  final FilasPorSincronizar filasSinc;
  ComparadorFilas(this.filasSinc);

  void detectar({required List<dynamic> local, required List<dynamic> remote}) {
    final mapLocal = {for (var e in local) e['id'] as String: e};
    final mapRemote = {for (var e in remote) e['id'] as String: e};

    for (final entry in mapRemote.entries) {
      final String id = entry.key;
      final remoto = entry.value;
      if (mapLocal.containsKey(id)) {
        final localFila = mapLocal[id]!;
        if (remoto['hash'] != localFila['hash']) {
          _resolverConflicto(id, localFila, remoto);
        }
      } else if (remoto['is_delete'] == 0) {
        filasSinc.insertToLocal.add(id);
      }
    }

    for (final String id in mapLocal.keys) {
      if (!mapRemote.containsKey(id) && mapLocal[id]!['is_delete'] == 0) {
        filasSinc.insertToRemote.add(id);
      }
    }
  }

  void _resolverConflicto(
    String id,
    Map<String, dynamic> local,
    Map<String, dynamic> remoto,
  ) {
    if (remoto['version'] > local['version']) {
      _ganaRemoto(id, remoto);
    } else if (local['version'] > remoto['version']) {
      _ganaLocal(id, local);
    } else {
      final ganador = resolucionVersionIgual(id, remoto, {id: local});
      if (ganador == 'remoto') _ganaRemoto(id, remoto);
    }
  }

  void _ganaRemoto(String id, Map<String, dynamic> remoto) {
    filasSinc.discardedLocal.add(id);
    if (remoto['is_update'] == 1) filasSinc.updateToLocal.add(id);
    if (remoto['is_delete'] == 1) filasSinc.deleteToLocal.add(id);
  }

  void _ganaLocal(String id, Map<String, dynamic> local) {
    if (local['is_update'] == 1) filasSinc.updateToRemote.add(id);
    if (local['is_delete'] == 1) filasSinc.deleteToRemote.add(id);
  }
}

class SincronizadorLocal {
  Future<void> ejecutar(FilasPorSincronizar filas) async {
    // 2.1 borrados lógicos (estos sí van uno por uno)
    for (final String id in filas.deleteToLocal) {
      await _softDeleteLocal(id);
    }

    // 2.2 altas remotas → traer DTOs en bloque y guardar
    if (filas.insertToLocal.isNotEmpty) {
      final dtos = await getFloraRemotoPorIds(filas.insertToLocal);

      final especies = dtos.map((dto) => EspecieMapper.fromDto(dto)).toList();

      if (especies.isNotEmpty) {
        await insertFloraLocal(especies);
      }
    }

    // 2.3 updates remotos → traer DTOs en bloque y actualizar
    if (filas.updateToLocal.isNotEmpty) {
      final dtos = await getFloraRemotoPorIds(filas.updateToLocal);

      for (final dto in dtos) {
        final esp = EspecieMapper.fromDto(dto);
        await updateFloraLocal(esp);
      }
    }
  }

  Future<void> _softDeleteLocal(String id) async {
    final db = await dbLocal.instancia;
    await db.update(
      'Flora',
      {'isDelete': 1},
      where: 'nombreCientifico = ?',
      whereArgs: [id],
    );
  }
}

class SincronizadorRemoto {
  Future<void> ejecutar(FilasPorSincronizar filas) async {
    final db = await dbLocal.instancia;

    // 3.1  altas locales → DTO → remoto
    for (final id in filas.insertToRemote) {
      final maps = await db.query(
        'Flora',
        where: 'nombreCientifico = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        final dbModel = EspecieDb.fromRow(maps.first);
        final esp = EspecieMapper.fromDb(dbModel);
        final dto = esp.toDto();
        await insertFloraRemoto(dto);
      }
    }

    // 3.2  updates locales → DTO → remoto
    for (final id in filas.updateToRemote) {
      final maps = await db.query(
        'Flora',
        where: 'nombreCientifico = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        final dbModel = EspecieDb.fromRow(maps.first);
        final esp = EspecieMapper.fromDb(dbModel);
        final dto = esp.toDto();
        await updateFloraRemoto(dto);
      }
    }

    // 3.3  borrados → remoto
    for (final id in filas.deleteToRemote) {
      await deleteFloraRemoto(id);
    }
  }
}

class SyncService {
  final FilasPorSincronizar state;
  late final ComparadorFilas detector;
  SyncService() : state = FilasPorSincronizar() {
    detector = ComparadorFilas(state);
  }
  final SincronizadorLocal localSync = SincronizadorLocal();
  final SincronizadorRemoto remoteSync = SincronizadorRemoto();

  Future<void> sincronizar() async {
    final db = await dbLocal.instancia;
    state.clear();

    // 4.1  obtenemos metadatos (sin imágenes)
    //final local = await _obtenerMetaLocal();
    //final remote = await _obtenerMetaRemoto();

    // 3.  Comparar solo las filas actualizadas despues de la ultima sincronizacion
    final ult = await db.query('ultima_sinc', limit: 1);
    final ultSinc =
        ult.isEmpty
            ? '1970-01-01T00:00:00Z'
            : ult.first['fecha_sincronizacion'] as String;
    final localMeta = await obtenerCambiosLocales(ultSinc);
    final remoteMeta = await obtenerCambiosRemotos(ultSinc);
    debugPrint('metas local: $localMeta');
    debugPrint('metas remoto: $remoteMeta');
    detector.detectar(local: localMeta, remote: remoteMeta);

    // 4.3  aplicar
    await localSync.ejecutar(state);
    await remoteSync.ejecutar(state);

    // 4.  Al terminar, guardar nueva marca y listas de IDs procesados
    final ahora = DateTime.now().toIso8601String();
    final idsLoc = localMeta.map((m) => m['id'] as String).toList();
    final idsRem = remoteMeta.map((m) => m['id'] as String).toList();

    await db.update('ultima_sinc', {
      'fecha_sincronizacion': ahora,
      'registros_locales_procesados': jsonEncode(idsLoc),
      'registros_remotos_procesados': jsonEncode(idsRem),
    });
  }

  /* obtener filas actualizadas despues de la ultima sincronizacion */

  // 1.  Obtener filas locales que cambiaron después de la última marca
  Future<List<Map<String, dynamic>>> obtenerCambiosLocales(
    String ultSinc,
  ) async {
    final db = await dbLocal.instancia;
    return db.rawQuery(
      '''
      SELECT s.id, s.hash, s.version, s.is_new, s.is_update, s.is_delete, f.last_upd
      FROM   sincronizacion s
      JOIN   Flora f ON s.id = f.nombreCientifico
      WHERE  f.last_upd > ?
    ''',
      [ultSinc],
    );
  }

  // 2.  Obtener filas remotas que cambiaron después de la misma marca
  Future<List<Map<String, dynamic>>> obtenerCambiosRemotos(
    String ultSinc,
  ) async {
    final filasSync = await getFloraRemoteSincronizacion(ultSinc);
    debugPrint('los metadatos de sincronizacion: $filasSync');
    return filasSync.map((fila) {
      return {
        'id': fila['id'],
        'hash': fila['hash'],
        'version': fila['version'],
        'is_new': fila['is_new'],
        'is_update': fila['is_update'],
        'is_delete': fila['is_delete'],
        'last_upd': fila['last_upd'],
      };
    }).toList();
  }

  /* ----------  obtención de metadatos  ---------- */
  /* Future<List<Map<String, dynamic>>> _obtenerMetaLocal() async {
    final db = await dbLocal.instancia;
    final flora = await db.query('Flora');
    return flora.map((r) {
      final String id = r['nombreCientifico'] as String;
      return {
        'id': id,
        'hash': calcularHash(r),
        'version': 1,
        'is_update': 0,
        'is_delete': r['isDelete'] == 1 ? 1 : 0,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _obtenerMetaRemoto() async {
    final dtos = await getFloraRemoto();
    return dtos.map((dto) {
      final id = dto.nombrecientifico;
      final map = dto.toJson();
      return {
        'id': id,
        'hash': calcularHash(map),
        'version': 1,
        'is_update': 0,
        'is_delete': 0,
      };
    }).toList();
  }*/
}
