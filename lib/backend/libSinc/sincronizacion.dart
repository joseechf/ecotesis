import '../llamadas_locales/llamadas_flora.dart';
import '../llamadas_remotas/llamadas_flora.dart';
import '../llamadas_locales/sqlite_helper.dart';
import '../../domain/adapter/mapper.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/especie_unificada.dart';
import '../llamadas_locales/tabla_sinc.dart';
import 'validar_metadatos.dart';

class FilasPorSincronizar {
  static final FilasPorSincronizar _instancia =
      FilasPorSincronizar._singleton();

  factory FilasPorSincronizar() {
    return _instancia;
  }

  FilasPorSincronizar._singleton();

  final List<String> insertToLocal = [],
      updateToLocal = [],
      deleteToLocal = [],
      eliminarFisicoLocal = [];

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
    eliminarFisicoLocal.clear();
  }
}

class ComparadorFilas {
  final FilasPorSincronizar filasSinc;
  ComparadorFilas(this.filasSinc);

  void detectar({
    required List<dynamic> localCompleto,
    required List<dynamic> remoteCompleto,
    required List<dynamic> localCambios,
    required List<dynamic> remoteCambios,
  }) {
    debugPrint('================ DETECTAR CAMBIOS ================');
    debugPrint('Local cambios: ${localCambios.length}');
    debugPrint('Remote cambios: ${remoteCambios.length}');

    final mapLocalCompleto = {
      for (var e in localCompleto) e['id'] as String: e,
    };
    final mapRemoteCompleto = {
      for (var e in remoteCompleto) e['id'] as String: e,
    };

    final mapLocalCambios = {for (var e in localCambios) e['id'] as String: e};
    final mapRemoteCambios = {
      for (var e in remoteCambios) e['id'] as String: e,
    };

    final todosLosIds = {...mapLocalCompleto.keys, ...mapRemoteCompleto.keys};

    for (final id in todosLosIds) {
      final localExiste = mapLocalCompleto.containsKey(id);
      final remoteExiste = mapRemoteCompleto.containsKey(id);

      final localCambio = mapLocalCambios[id];
      final remoteCambio = mapRemoteCambios[id];

      final localFila = mapLocalCompleto[id];
      final remoteFila = mapRemoteCompleto[id];

      debugPrint(' Analizando ID: $id');

      // Existe en ambos lados
      if (localExiste && remoteExiste) {
        final local = localFila!;
        final remote = remoteFila!;

        // DELETE conflict
        if (local['is_delete'] == 1 || remote['is_delete'] == 1) {
          debugPrint('  Conflicto DELETE detectado');
          _resolverConflictoDelete(id, local, remote);
          continue;
        }

        // Ambos cambiaron
        if (localCambio != null && remoteCambio != null) {
          debugPrint('   Ambos modificaron → resolver conflicto');
          _resolverConflicto(id, local, remote);
          continue;
        }

        // Solo local cambió
        if (localCambio != null) {
          debugPrint('   Update local → enviar a remoto');
          filasSinc.updateToRemote.add(id);
          continue;
        }

        // Solo remoto cambió
        if (remoteCambio != null) {
          debugPrint('  Update remoto → aplicar en local');
          filasSinc.updateToLocal.add(id);
          continue;
        }

        debugPrint(' Sin cambios');
      }
      // Existe solo en remoto
      else if (!localExiste && remoteExiste) {
        final remote = remoteFila!;
        if (remote['is_delete'] == 0) {
          debugPrint('  Nuevo en remoto → insertar en local');
          filasSinc.insertToLocal.add(id);
        }
      }
      // Existe solo en local
      else if (localExiste && !remoteExiste) {
        final local = localFila!;
        if (local['is_delete'] == 0) {
          debugPrint('  Nuevo en local → insertar en remoto');
          filasSinc.insertToRemote.add(id);
        } else {
          //eliminar por completo especie local
          filasSinc.eliminarFisicoLocal.add(id);
        }
      }
    }

    debugPrint('================ RESULTADO DETECCIÓN ================');
    debugPrint('insertToLocal: ${filasSinc.insertToLocal}');
    debugPrint('updateToLocal: ${filasSinc.updateToLocal}');
    debugPrint('deleteToLocal: ${filasSinc.deleteToLocal}');
    debugPrint('insertToRemote: ${filasSinc.insertToRemote}');
    debugPrint('updateToRemote: ${filasSinc.updateToRemote}');
    debugPrint('deleteToRemote: ${filasSinc.deleteToRemote}');
  }

  void _resolverConflictoDelete(
    String id,
    Map<String, dynamic> local,
    Map<String, dynamic> remoto,
  ) {
    final vLocal = local['version'];
    final vRemoto = remoto['version'];

    debugPrint('Resolver conflicto DELETE: $id');
    debugPrint('   Local version: $vLocal');
    debugPrint('   Remote version: $vRemoto');

    // Ambos ya eliminados
    if (local['is_delete'] == 1 && remoto['is_delete'] == 1) {
      debugPrint('   Ambos eliminados → limpieza posterior');
      filasSinc.eliminarFisicoLocal.add(id);
      return;
    }

    if (vRemoto > vLocal) {
      debugPrint('   Gana remoto');

      if (remoto['is_delete'] == 1) {
        //eliminar por completo local porque esta eliminado en remoto
        filasSinc.eliminarFisicoLocal.add(id);
      } else {
        filasSinc.updateToLocal.add(id);
      }
    } else if (vLocal > vRemoto) {
      debugPrint('   Gana local');

      if (local['is_delete'] == 1) {
        //eliminar en remoto y luego eliminar por completo local porque ya no se va a usar
        filasSinc.deleteToRemote.add(id);
        debugPrint('eliminar remoto: $id');
        filasSinc.eliminarFisicoLocal.add(id);
      } else {
        debugPrint('no se elimina: $id');
        filasSinc.updateToRemote.add(id);
      }
    } else {
      //versiones iguales gana remoto
      debugPrint('   Version igual → gana remoto');

      if (remoto['is_delete'] == 1) {
        //eliminar en remoto y luego eliminar por completo local porque ya no se va a usar
        filasSinc.eliminarFisicoLocal.add(id);
      } else {
        filasSinc.updateToLocal.add(id);
      }
    }
  }

  void _resolverConflicto(
    String id,
    Map<String, dynamic> local,
    Map<String, dynamic> remoto,
  ) {
    if (remoto['version'] > local['version']) {
      debugPrint(
        'version remoto mayor: (${remoto['version']} > ${local['version']})',
      );
      filasSinc.updateToLocal.add(id);
    } else if (local['version'] > remoto['version']) {
      debugPrint(
        'version local mayor: (${remoto['version']} < ${local['version']})',
      );
      filasSinc.updateToRemote.add(id);
    } else {
      debugPrint(
        'version igual: (${remoto['version']} == ${local['version']})',
      );
      filasSinc.updateToLocal.add(id); //versiones iguales gana remoto
    }
  }
}

class SincronizadorLocal {
  Future<bool> ejecutar(FilasPorSincronizar filas) async {
    debugPrint('=========== SINCRONIZADOR LOCAL ===========');

    final db = await dbLocal.instancia;

    debugPrint(' deleteToLocal: ${filas.deleteToLocal}');
    debugPrint(' eliminar Fisicamente: ${filas.eliminarFisicoLocal}');
    debugPrint(' insertToLocal: ${filas.insertToLocal}');
    debugPrint(' updateToLocal: ${filas.updateToLocal}');

    for (final String id in filas.deleteToLocal) {
      debugPrint('Aplicando soft delete LOCAL: $id');
      await _softDeleteLocal(id);
    }

    for (final String id in filas.eliminarFisicoLocal) {
      debugPrint('Aplicando eliminacion fisica LOCAL: $id');
      await _deleteFisicoLocal(id);
    }

    if (filas.insertToLocal.isNotEmpty) {
      debugPrint('Solicitando al API inserts remotos...');
      final response = await obtenerFloraRemotaById(filas.insertToLocal);
      debugPrint('Respuesta API inserts: ${response.length} registros');

      final especies =
          response
              .map((json) => adaptarRemotoAJsonDominio(json))
              .map((jsonAdaptado) => Especie.fromJson(jsonAdaptado))
              .toList();

      for (final e in especies) {
        debugPrint('Insertando LOCAL especie: ${e.nombreCientifico}');
      }

      if (especies.isNotEmpty) {
        await insertFloraLocal(db, especies);
      }
    }

    if (filas.updateToLocal.isNotEmpty) {
      debugPrint('Solicitando al API updates remotos...');
      final response = await obtenerFloraRemotaById(filas.updateToLocal);
      debugPrint('Respuesta API updates: ${response.length} registros');

      final especies =
          response
              .map((json) => adaptarRemotoAJsonDominio(json))
              .map((jsonAdaptado) => Especie.fromJson(jsonAdaptado))
              .toList();

      for (final esp in especies) {
        debugPrint('Actualizando LOCAL especie: ${esp.nombreCientifico}');
        await updateFloraLocal(db, esp);
      }
    }
    return true;
  }

  Future<void> _softDeleteLocal(String id) async {
    final db = await dbLocal.instancia;
    await softDeleteLocal(db, id);
  }

  Future<void> _deleteFisicoLocal(String id) async {
    final db = await dbLocal.instancia;
    await deleteFloraLocal(db, id);
  }
}

class SincronizadorRemoto {
  //cada id es una query, puedo cambiarlo para trerlos de golpe
  Future<bool> ejecutar(FilasPorSincronizar filas) async {
    final db = await dbLocal.instancia;
    // 1️ Altas locales → remoto
    for (final id in filas.insertToRemote) {
      final especie = await obtenerFloraLocalById(db, id);
      if (especie != null) {
        await insertFloraRemoto(especie);
      }
    }

    // 2️ Updates locales → remoto
    for (final id in filas.updateToRemote) {
      final especie = await obtenerFloraLocalById(db, id);
      if (especie != null) {
        await updateFloraRemoto(especie);
      }
    }

    // 3️ Borrados → remoto
    for (final id in filas.deleteToRemote) {
      await softDeleteFloraRemoto(id);
    }
    return true;
  }
}

class ControlSincronizacion {
  static final ControlSincronizacion _instancia =
      ControlSincronizacion._singleton();
  final FilasPorSincronizar state;
  late final ComparadorFilas detector;
  factory ControlSincronizacion() {
    return _instancia;
  }
  ControlSincronizacion._singleton() : state = FilasPorSincronizar() {
    detector = ComparadorFilas(state);
  }

  final SincronizadorLocal localSync = SincronizadorLocal();
  final SincronizadorRemoto remoteSync = SincronizadorRemoto();
  final TablaSyncLocal tablaSyncLocal = TablaSyncLocal();

  Future<void> sincronizar() async {
    debugPrint(' ============= limpiar metadatos huerfanos ==============');
    await limpiarHuerfanos();

    debugPrint('================ SINCRONIZACIÓN INICIADA ================');

    final db = await dbLocal.instancia;
    state.clear();

    final ult = await db.query('ultima_sinc', limit: 1);
    final ultSinc =
        ult.isEmpty
            ? '1970-01-01T00:00:00Z'
            : ult.first['fecha_sincronizacion'] as String;

    debugPrint('Última sincronización: $ultSinc');

    final localCambios = await obtenerCambiosLocales(ultSinc);
    final remoteCambios = await obtenerCambiosRemotos(ultSinc);
    List<Map<String, dynamic>>? localCompleto = [];
    List<Map<String, dynamic>>? remoteCompleto = [];

    localCompleto = await obtenerLocalCompleto();
    remoteCompleto = await obtenerRemotoCompleto();

    debugPrint(
      'localCambios IDs: ${localCambios.map((e) => e['id']).toList()}',
    );
    debugPrint(
      'remoteCambios IDs: ${remoteCambios.map((e) => e['id']).toList()}',
    );

    detector.detectar(
      localCambios: localCambios,
      remoteCambios: remoteCambios,
      localCompleto: localCompleto,
      remoteCompleto: remoteCompleto,
    );

    bool ok = await remoteSync.ejecutar(state);
    if (ok) {
      ok = await localSync.ejecutar(state);
      if (!ok) {
        debugPrint('LA SINCRONIZACION LOCAL FALLÓ !!!! ');
        return;
      }
    } else {
      debugPrint('LA SINCRONIZACION REMOTA FALLÓ !!!! ');
      return;
    }

    final ahora = DateTime.now().toUtc().toIso8601String();
    debugPrint('Nueva marca de sincronización: $ahora');

    final idsLoc = localCambios.map((m) => m['id'] as String).toList();
    final idsRem = remoteCambios.map((m) => m['id'] as String).toList();

    await tablaSyncLocal.guardarUltimaSincronizacion(
      db: db,
      fecha: ahora,
      idsLoc: idsLoc,
      idsRem: idsRem,
    );

    debugPrint('================ SINCRONIZACIÓN FINALIZADA ================');
  }

  /* obtener filas actualizadas despues de la ultima sincronizacion */

  Future<List<Map<String, dynamic>>> obtenerCambiosLocales(
    String ultSinc,
  ) async {
    final db = await dbLocal.instancia;
    final data = await selectLocal(
      db: db,
      tabla: 'sincronizacion',
      where: 'last_upd > ?',
      whereArgs: [ultSinc],
    );
    for (final d in data) {
      debugPrint('metadata con where: ${d['id']}');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> obtenerLocalCompleto() async {
    final db = await dbLocal.instancia;
    final datos = await selectLocal(db: db, tabla: 'sincronizacion');
    return datos;
  }

  Future<List<Map<String, dynamic>>> obtenerCambiosRemotos(
    String ultSinc,
  ) async {
    final filasSync = await getFloraRemoteSincronizacion(ultSinc: ultSinc);
    return filasSync.map((fila) {
      return {
        'id': fila['id'],
        'hash': fila['hash'],
        'version': fila['version'],
        'is_new': (fila['is_new']) ? 1 : 0,
        'is_update': (fila['is_update']) ? 1 : 0,
        'is_delete': (fila['is_delete']) ? 1 : 0,
        'last_upd': fila['last_upd'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> obtenerRemotoCompleto() async {
    final filas = await getFloraRemoteSincronizacion();

    return filas.map((fila) {
      return {
        'id': fila['id'],
        'hash': fila['hash'],
        'version': fila['version'],
        'is_new': (fila['is_new']) ? 1 : 0,
        'is_update': (fila['is_update']) ? 1 : 0,
        'is_delete': (fila['is_delete']) ? 1 : 0,
        'last_upd': fila['last_upd'],
      };
    }).toList();
  }
}
