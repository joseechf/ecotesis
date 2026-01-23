import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/especie.dart';
import '../../../data/models/especie_db.dart';
import '../../../data/mappers/especie_mapper.dart';
import 'sqliteHelper.dart';
import 'tablaSinc.dart';

final _sync = TablaSyncLocal();
final _db = dbLocal.instancia;

// 1.  LECTURA  →  devuelve List<Especie> (dominio)
Future<List<Especie>> cargarFloraLocal() async {
  final db = await _db;
  try {
    // 1.1  flora maestra
    final floraMaps = await db.query('Flora');
    if (floraMaps.isEmpty) return [];

    final resultado = <Especie>[];

    for (final flora in floraMaps) {
      final nombreC = flora['nombre_cientifico'] as String;

      // 1.2  tablas hijas
      final nombres = await db.query(
        'NombreComun',
        where: 'nombre_cientifico = ?',
        whereArgs: [nombreC],
      );

      final utils = await db.query(
        'Utilidad',
        where: 'nombre_cientifico = ?',
        whereArgs: [nombreC],
      );

      final origs = await db.query(
        'Origen',
        where: 'nombre_cientifico = ?',
        whereArgs: [nombreC],
      );

      // 1.3  unir todo en un solo mapa
      final completo = Map<String, dynamic>.from(flora);
      completo['nombres_comunes'] =
          nombres.map((r) => r['nombre_comun']).toList();
      completo['utilidades'] = utils.map((r) => r['utilidad']).toList();
      completo['origenes'] = origs.map((r) => r['origen']).toList();

      // 1.4  DB → Dominio
      resultado.add(EspecieMapper.fromDb(EspecieDb.fromRow(completo)));
    }

    return resultado;
  } catch (e) {
    debugPrint('cargarFloraLocal error: $e');
    return [];
  }
}

//   2.  INSERCIÓN  →  recibe List<Especie>
Future<bool> insertFloraLocal(List<Especie> especies) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      for (final esp in especies) {
        //  1. INSERT / UPDATE TABLA MAESTRA (Flora)
        final floraRow = esp.toDb().toRow();

        await txn.insert(
          'Flora',
          floraRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        //    2. INSERT / UPDATE TABLAS HIJAS
        await _insertarVO(
          txn,
          'NombreComun',
          'nombre_comun',
          esp.nombreCientifico,
          esp.nombresComunes.map((n) => n.nombreComun),
        );

        await _insertarVO(
          txn,
          'Utilidad',
          'utilidad',
          esp.nombreCientifico,
          esp.utilidades.map((u) => u.utilidad),
        );

        await _insertarVO(
          txn,
          'Origen',
          'origen',
          esp.nombreCientifico,
          esp.origenes.map((o) => o.origen),
        );

        // 3. SNAPSHOT AGRUPADO DE LA ESPECIE (PARA SINCRONIZACIÓN)
        final hashearEspecie = {
          'flora': floraRow,
          'nombres_comunes':
              esp.nombresComunes.map((n) => n.nombreComun).toList()..sort(),
          'utilidades': esp.utilidades.map((u) => u.utilidad).toList()..sort(),
          'origenes': esp.origenes.map((o) => o.origen).toList()..sort(),
        };

        // 4. REGISTRO ÚNICO DE SINCRONIZACIÓN POR ESPECIE
        final ok = await _sync.registrarUpsert(
          txn,
          esp.nombreCientifico,
          hashearEspecie,
        );

        if (!ok) {
          throw 'problemas al registrar sincronización de especie';
        }
      }
    });

    return true;
  } catch (e) {
    debugPrint('insertFloraLocal error: $e');
    return false;
  }
}

// 3.  ACTUALIZACIÓN
Future<bool> updateFloraLocal(Especie esp) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      final floraRow = esp.toDb().toRow();

      await txn.update(
        'Flora',
        floraRow,
        where: 'nombre_cientifico = ?',
        whereArgs: [esp.nombreCientifico],
      );

      // borrar hijas
      await _borrarVO(txn, esp.nombreCientifico);

      // reinsertar hijas
      await _insertarVO(
        txn,
        'NombreComun',
        'nombre_comun',
        esp.nombreCientifico,
        esp.nombresComunes.map((n) => n.nombreComun),
      );

      await _insertarVO(
        txn,
        'Utilidad',
        'utilidad',
        esp.nombreCientifico,
        esp.utilidades.map((u) => u.utilidad),
      );

      await _insertarVO(
        txn,
        'Origen',
        'origen',
        esp.nombreCientifico,
        esp.origenes.map((o) => o.origen),
      );

      final snapshotEspecie = {
        'flora': floraRow,
        'nombres_comunes':
            esp.nombresComunes.map((n) => n.nombreComun).toList()..sort(),
        'utilidades': esp.utilidades.map((u) => u.utilidad).toList()..sort(),
        'origenes': esp.origenes.map((o) => o.origen).toList()..sort(),
      };

      final ok = await _sync.registrarUpsert(
        txn,
        esp.nombreCientifico, // 🔑 1 ID = 1 especie
        snapshotEspecie,
      );

      if (!ok) {
        throw 'problemas al registrar sincronización de especie';
      }
    });

    return true;
  } catch (e) {
    debugPrint('updateFloraLocal error: $e');
    return false;
  }
}

//  4.  ELIMINACIÓN
Future<bool> deleteFloraLocal(String nombreCientifico) async {
  final db = await _db;

  try {
    return await db.transaction((txn) async {
      /* =========================================================
         1. BORRAR TABLAS HIJAS
         ========================================================= */
      await _borrarVO(txn, nombreCientifico);

      /* =========================================================
         2. BORRAR TABLA MAESTRA (Flora)
         ========================================================= */
      final filas = await txn.delete(
        'Flora',
        where: 'nombre_cientifico = ?',
        whereArgs: [nombreCientifico],
      );

      if (filas == 0) {
        throw 'no existe la especie a eliminar';
      }

      /* =========================================================
         3. REGISTRAR SOFT DELETE EN SINCRONIZACIÓN (POR ESPECIE)
         ========================================================= */
      final ok = await _sync.registrarBorrado(
        txn,
        nombreCientifico, // 🔑 1 ID = 1 especie
      );

      if (!ok) {
        throw 'problemas al registrar softdelete en sincronización';
      }

      return true;
    });
  } catch (e) {
    debugPrint('deleteFloraLocal error: $e');
    return false;
  }
}

// 5.  HELPERS PRIVADOS
Future<void> _insertarVO(
  Transaction txn,
  String tabla,
  String colValor,
  String nombreCientifico,
  Iterable<String> valores,
) async {
  if (valores.isEmpty) return;

  await txn.delete(
    tabla,
    where: 'nombre_cientifico = ?',
    whereArgs: [nombreCientifico],
  );

  for (final v in valores) {
    final row = {'nombre_cientifico': nombreCientifico, colValor: v};

    final res = await txn.insert(
      tabla,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (res != 1) throw 'problemas insert Flora local';
  }
}

Future<void> _borrarVO(Transaction txn, String nombreCientifico) async {
  try {
    await txn.delete(
      'NombreComun',
      where: 'nombre_cientifico = ?',
      whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Utilidad',
      where: 'nombre_cientifico = ?',
      whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Origen',
      where: 'nombre_cientifico = ?',
      whereArgs: [nombreCientifico],
    );
  } catch (e) {
    debugPrint('delete VO error: $e');
  }
}
