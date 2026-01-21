import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/especie.dart';
import '../../../data/models/especie_db.dart';
import '../../../data/mappers/especie_mapper.dart';
import 'sqliteHelper.dart';
import 'tablaSinc.dart';

final _sync = TablaSyncLocal();
final _db = dbLocal.instancia;

/* =========================================================
   1.  LECTURA  →  devuelve List<Especie> (dominio)
   ========================================================= */
Future<List<Especie>> cargarFloraLocal() async {
  final db = await _db;
  try {
    // 1.1  flora maestra
    final floraMaps = await db.query('Flora');
    if (floraMaps.isEmpty) return [];

    // 1.2  para cada especie → leer tablas hijas
    final resultado = <Especie>[];
    for (final flora in floraMaps) {
      final nombreC = flora['nombreCientifico'] as String;

      final nombres = await db.query(
        'NombreComun',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreC],
      );
      final utils = await db.query(
        'Utilidad',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreC],
      );
      final origs = await db.query(
        'Origen',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreC],
      );

      // 1.3  unir todo en un único mapa “completo”
      final completo = Map<String, dynamic>.from(flora);
      completo['nombres_comunes'] =
          nombres.map((r) => r['nombreComun']).toList();
      completo['utilidades'] = utils.map((r) => r['utilidad']).toList();
      completo['origenes'] = origs.map((r) => r['origen']).toList();

      // 1.4  mapa → DB model → dominio
      resultado.add(EspecieMapper.fromDb(EspecieDb.fromRow(completo)));
    }
    return resultado;
  } catch (e) {
    debugPrint('cargarEspeciesLocal: $e');
    return [];
  }
}

/* =========================================================
   2.  INSERCIÓN  →  recibe List<Especie> (dominio)
   ========================================================= */
Future<bool> insertFloraLocal(List<Especie> especies) async {
  final db = await _db;
  try {
    await db.transaction((txn) async {
      for (final esp in especies) {
        // 2.1  convertir a row de SQLite
        final row = esp.toDb().toRow();

        // 2.2  guardar maestro
        await txn.insert(
          'Flora',
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await _sync.registrarUpsert(txn, 'Flora', row['nombreCientifico'], row);

        // 2.3  tablas hijas
        await _insertarVO(
          txn,
          'NombreComun',
          'nombreComun',
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
      }
    });
    return true;
  } catch (e) {
    debugPrint('insertarEspeciesLocal: $e');
    return false;
  }
}

/* =========================================================
   3.  ACTUALIZACIÓN  →  una sola especie
   ========================================================= */
Future<bool> updateFloraLocal(Especie esp) async {
  final db = await _db;
  try {
    await db.transaction((txn) async {
      // 3.1  maestro
      final row = esp.toDb().toRow();
      await txn.update(
        'Flora',
        row,
        where: 'nombreCientifico = ?',
        whereArgs: [esp.nombreCientifico],
      );
      await _sync.registrarUpsert(txn, 'Flora', esp.nombreCientifico, row);

      // 3.2  borrar y reinsertar hijas
      await _borrarVO(txn, esp.nombreCientifico);
      await _insertarVO(
        txn,
        'NombreComun',
        'nombreComun',
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
    });
    return true;
  } catch (e) {
    debugPrint('actualizarEspecieLocal: $e');
    return false;
  }
}

/* =========================================================
   4.  ELIMINACIÓN
   ========================================================= */
Future<bool> deleteFloraLocal(String nombreCientifico) async {
  final db = await _db;
  try {
    return await db.transaction((txn) async {
      await _borrarVO(txn, nombreCientifico);
      final filas = await txn.delete(
        'Flora',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );
      await _sync.registrarBorrado(txn, 'Flora', nombreCientifico);
      return filas > 0;
    });
  } catch (e) {
    debugPrint('eliminarEspecieLocal: $e');
    return false;
  }
}

/* =========================================================
   5.  HELPERS PRIVADOS
   ========================================================= */
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
    where: 'nombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
  for (final v in valores) {
    final row = {'nombreCientifico': nombreCientifico, colValor: v};
    await txn.insert(tabla, row, conflictAlgorithm: ConflictAlgorithm.replace);
    await _sync.registrarUpsert(txn, tabla, '$nombreCientifico|$v', row);
  }
}

Future<void> _borrarVO(Transaction txn, String nombreCientifico) async {
  await txn.delete(
    'NombreComun',
    where: 'nombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
  await txn.delete(
    'Utilidad',
    where: 'nombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
  await txn.delete(
    'Origen',
    where: 'nombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
}
