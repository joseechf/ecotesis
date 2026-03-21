import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/especie_unificada.dart';
import 'sqlite_helper.dart';
import 'tabla_sinc.dart';
import '../../domain/value_objects.dart';

final _sync = TablaSyncLocal();
final _db = dbLocal.instancia;
const String campoNombreCientifico = 'nombre_cientifico';

Future<List<Map<String, dynamic>>> selectLocal({
  required String tabla,
  String? where,
  List<Object?>? whereArgs,
}) async {
  final db = await _db;

  const tablasPermitidas = {'sincronizacion', 'Flora'};
  if (!tablasPermitidas.contains(tabla)) {
    throw Exception('Tabla no permitida');
  }
  return await db.query(
    tabla,
    columns: [
      'id',
      'hash',
      'version',
      'is_new',
      'is_update',
      'is_delete',
      'last_upd',
    ],
    where: where,
    whereArgs: whereArgs,
  );
}

Future<List<Especie>> cargarFloraLocal() async {
  final db = await _db;

  final floraMaps = await db.query('Flora');
  if (floraMaps.isEmpty) return [];

  final resultado = <Especie>[];

  for (final flora in floraMaps) {
    final especie = await _mapearEspecieCompleta(db, flora);
    resultado.add(especie);
  }

  return resultado;
}

Future<Map<String, dynamic>?> obtenerFloraLocalById(
  String nombreCientifico,
) async {
  final db = await _db;

  final floraMaps = await db.query(
    'Flora',
    where: '$campoNombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );

  if (floraMaps.isEmpty) return null;
  final especie = await _mapearEspecieCompleta(db, floraMaps.first);
  final json = especie.toJson();
  return json;
}

Future<Especie> _mapearEspecieCompleta(
  Database db,
  Map<String, dynamic> flora,
) async {
  final nombreC = flora[campoNombreCientifico] as String;

  final nombresRows = await db.query(
    'NombreComun',
    where: '$campoNombreCientifico = ?',
    whereArgs: [nombreC],
  );

  final utilRows = await db.query(
    'Utilidad',
    where: '$campoNombreCientifico = ?',
    whereArgs: [nombreC],
  );

  final origenRows = await db.query(
    'Origen',
    where: '$campoNombreCientifico = ?',
    whereArgs: [nombreC],
  );

  return Especie.fromDbMap(
    row: flora,
    nombresComunes: nombresRows.map((r) => NombreComun.fromRow(r)).toList(),
    utilidades: utilRows.map((r) => Utilidad.fromRow(r)).toList(),
    origenes: origenRows.map((r) => Origen.fromRow(r)).toList(),
  );
}

Map<String, dynamic> estructurarHash(
  Map<String, dynamic> floraRow,
  Especie esp,
) {
  return {
    ...floraRow,
    'NombreComun':
        esp.nombresComunes.map((n) => {'nombre_comun': n.nombreComun}).toList()
          ..sort(
            (a, b) => (a['nombre_comun'] as String).compareTo(
              b['nombre_comun'] as String,
            ),
          ),
    'Utilidad':
        esp.utilidades.map((u) => {'utilidad': u.utilidad}).toList()..sort(
          (a, b) =>
              (a['utilidad'] as String).compareTo(b['utilidad'] as String),
        ),
    'Origen':
        esp.origenes.map((o) => {'origen': o.origen}).toList()..sort(
          (a, b) => (a['origen'] as String).compareTo(b['origen'] as String),
        ),
  };
}

Future<void> _guardarRelacionesYSync(
  Transaction txn,
  Especie esp,
  Map<String, dynamic> floraRow,
) async {
  for (final n in esp.nombresComunes) {
    await txn.insert('NombreComun', n.toRow(esp.nombreCientifico));
  }

  for (final u in esp.utilidades) {
    await txn.insert('Utilidad', u.toRow(esp.nombreCientifico));
  }

  for (final o in esp.origenes) {
    await txn.insert('Origen', o.toRow(esp.nombreCientifico));
  }

  final snapshotEspecie = estructurarHash(floraRow, esp);

  debugPrint('voy a hashear: $snapshotEspecie');
  final ok = await _sync.registrarSync(
    tx: txn,
    id: esp.nombreCientifico,
    fila: snapshotEspecie,
  );

  if (!ok) {
    throw 'problemas al registrar sincronización de especie';
  }
}

Future<bool> insertFloraLocal(List<Especie> especies) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      for (final esp in especies) {
        final floraRow = esp.toDbRow();

        await txn.insert(
          'Flora',
          floraRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await _guardarRelacionesYSync(txn, esp, floraRow);
      }
    });

    return true;
  } catch (e) {
    debugPrint('insertFloraLocal error: $e');
    return false;
  }
}

Future<bool> updateFloraLocal(Especie esp) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      final floraRow = esp.toDbRow();

      await txn.update(
        'Flora',
        floraRow,
        where: '$campoNombreCientifico = ?',
        whereArgs: [esp.nombreCientifico],
      );

      await _borrarVO(txn, esp.nombreCientifico);

      await _guardarRelacionesYSync(txn, esp, floraRow);
    });

    return true;
  } catch (e) {
    debugPrint('updateFloraLocal error: $e');
    return false;
  }
}

Future<bool> deleteFloraLocal(String nombreCientifico) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      await _borrarVO(txn, nombreCientifico);

      final ok = await txn.delete(
        'sincronizacion',
        where: '$campoNombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );

      if (ok == 0) {
        throw 'no existe metadatos de especie a eliminar';
      }

      final filas = await txn.delete(
        'Flora',
        where: '$campoNombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );

      if (filas == 0) {
        throw 'no existe la especie a eliminar';
      }
    });
    return true;
  } catch (e) {
    debugPrint('deleteFloraLocal error: $e');
    return false;
  }
}

Future<void> _borrarVO(Transaction txn, String nombreCientifico) async {
  try {
    await txn.delete(
      'NombreComun',
      where: '$campoNombreCientifico = ?',
      whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Utilidad',
      where: '$campoNombreCientifico = ?',
      whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Origen',
      where: '$campoNombreCientifico = ?',
      whereArgs: [nombreCientifico],
    );
  } catch (e) {
    debugPrint('delete VO error: $e');
  }
}

Future<bool> softDeleteLocal(String id) async {
  final db = await _db;

  try {
    await db.transaction((txn) async {
      final ok = await _sync.registrarBorrado(txn, id);
      if (!ok) {
        throw 'problemas al registrar softdelete en sincronización';
      }
    });
    return true;
  } catch (e) {
    debugPrint('soft delete error: $e');
    return false;
  }
}
