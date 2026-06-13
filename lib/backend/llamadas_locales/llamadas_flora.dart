import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/especie_unificada.dart';
import 'tabla_sinc.dart';
import '../../domain/value_objects.dart';

final _sync = TablaSyncLocal();
const String campoNombreCientifico = 'nombre_cientifico';

Future<List<Map<String,dynamic>>> selectLocal({
  required Database db,
  required String tabla,
  String? where,
  List<Object?>? whereArgs,
}) async {
  const tablasPermitidas = {'sincronizacion','Flora'};
  if(!tablasPermitidas.contains(tabla)){
    throw Exception('Tabla no permitida');
  }
  return await db.query(
    tabla,
    columns: ['*'],
    where: where,
    whereArgs: whereArgs,
  );
}

Future<List<Especie>> cargarFloraLocal(DatabaseExecutor db) async {
  //final floraMaps = await db.query('Flora');
  final floraActiva = await db.rawQuery('''
    SELECT f.* FROM Flora f LEFT JOIN sincronizacion s ON s.id = f.nombre_cientifico where COALESCE(s.is_delete,0) = 0
  ''');
  if(floraActiva.isEmpty) return [];
  final resultado = <Especie>[];

  for(final flora in floraActiva){
    final especie = await _mapearEspecieCompleta(db, flora);
    resultado.add(especie);
  }
  return resultado;
}

Future<Map<String, dynamic>?> obtenerFloraLocalById(
  Database db,
  String nombreCientifico,
) async {
  final floraMaps = await db.query(
    'Flora', where: '$campoNombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
  if(floraMaps.isEmpty) return null;
  final especie = await _mapearEspecieCompleta(db, floraMaps.first);
  final json = especie.toJson();
  return json;
}

Future<Especie> _mapearEspecieCompleta(
  DatabaseExecutor db,
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


Future<void> _guardarRelacionesYSync(
  Transaction txn,
  Especie esp,
  Map<String, dynamic> floraRow,
  int? version
) async {
  for( final n in esp.nombresComunes){
    await txn.insert('NombreComun', n.toRow(esp.nombreCientifico));
  }
  for( final n in esp.utilidades){
    await txn.insert('Utilidad', n.toRow(esp.nombreCientifico));
  }
  for( final n in esp.origenes){
    await txn.insert('Origen', n.toRow(esp.nombreCientifico));
  }

  final ok = await _sync.registrarSync(
    tx: txn, id: esp.nombreCientifico,versionRemota: version
  );
  if(!ok) {
    throw 'problemas al registrar sincronizacion de especie';
  }
}

Future<bool> insertFloraLocal(Database db, List<Especie> especies, Map<String, Map<String, dynamic>>? remoteMetaDataCompletaMap) async {
  try {
    await db.transaction((txn) async {
      for(final esp in especies) {
        late dynamic meta;
        int? version;
        if(remoteMetaDataCompletaMap != null){
           meta = remoteMetaDataCompletaMap[esp.nombreCientifico];
           version = meta?['version'] as int?;
        }
        
        final floraRow = esp.toDbRow();
        await txn.insert('Flora',floraRow,conflictAlgorithm: ConflictAlgorithm.replace);
        await _guardarRelacionesYSync(txn, esp, floraRow,version);
      }
    });
    return true;
  } catch (e) {
    debugPrint('Error insertFloraLocal $e');
    return false;
  }
}

Future<bool> updateFloraLocal(Database db, Especie esp, int? version) async {
  try {
    await db.transaction((txn) async {
      final floraRow = esp.toDbRow();
      final filas = await txn.update(
        'Flora',
        floraRow,
        where: '$campoNombreCientifico = ?',
        whereArgs: [esp.nombreCientifico],
      );
      if(filas == 0) {
        throw Exception('Especie no existe');
      }

      await _borrarVO(txn,esp.nombreCientifico);
      await _guardarRelacionesYSync(txn, esp, floraRow, version);
    });
    return true;
  } catch (e) {
    debugPrint('Error updateFloraLocal $e');
    return false;
  }
}

Future<bool>deleteFloraLocal(Database db, String? nombreCientifico) async {
  try {
    await db.transaction((txn) async {
      final filas = (nombreCientifico != null)
        ? await txn.delete('Flora', where: '$campoNombreCientifico = ?', whereArgs: [nombreCientifico]) : await txn.delete('Flora');
      if(nombreCientifico != null && filas == 0) {
        throw 'no existe la especie a eliminar';
      }

      const String identificador = 'id';
      (nombreCientifico != null) ? await txn.delete('sincronizacion', where: '$identificador = ?', whereArgs: [nombreCientifico],) : await txn.delete('sincronizacion');
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
      'NombreComun', where: '$campoNombreCientifico = ?', whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Utilidad', where: '$campoNombreCientifico = ?', whereArgs: [nombreCientifico],
    );
    await txn.delete(
      'Origen', where: '$campoNombreCientifico = ?', whereArgs: [nombreCientifico],
    );
  } catch (e) {
    debugPrint('delete VO error: $e');
  }
}
 
Future<bool> softDeleteLocal(Database db, String id, int? version) async {
  try {
    await db.transaction((txn) async {
      final ok = await _sync.registrarBorrado(txn, id, version);
      if(!ok) {
        throw 'problemas al registrar softdelete en sincronizacion';
      }
    });
    return true;
  } catch (e) {
    debugPrint('soft delete error: $e');
    return false;
  }
}