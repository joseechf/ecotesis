
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/especie_unificada.dart';
import 'tabla_sinc.dart';

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

Future<List<Especie>> cargarFloraLocalActiva(DatabaseExecutor db) async {
  //final floraMaps = await db.query('Flora');
  final floraActiva = await db.rawQuery('''
    SELECT fc.* FROM floraCompleta fc LEFT JOIN sincronizacion s ON s.id = fc.nombre_cientifico where COALESCE(s.is_delete,0) = 0
  ''');
  if(floraActiva.isEmpty) return [];
  return floraActiva.map((row) => Especie.fromJson(row)).toList();
}

Future<Map<String, dynamic>?> obtenerFloraLocalById(
  Database db,
  String nombreCientifico,
) async {
  final floraMaps = await db.query(
    'floraCompleta', where: '$campoNombreCientifico = ?',
    whereArgs: [nombreCientifico],
  );
  if(floraMaps.isEmpty) return null;
  final result = Especie.fromJson(floraMaps.first);
  return result.toJson();
}


Future<void> _guardarRelacionesYSync(
  Transaction txn,
  Especie esp,
  Map<String, dynamic> floraRow,
  int? version
) async {
  for( final n in esp.nombresComunes){
    await txn.insert('NombreComun', {...n.toMap(),'nombre_cientifico': esp.nombre_cientifico},conflictAlgorithm: ConflictAlgorithm.replace);
  }
  for( final u in esp.utilidades){
    await txn.insert('Utilidad', {...u.toMap(),'nombre_cientifico': esp.nombre_cientifico},conflictAlgorithm: ConflictAlgorithm.replace);
  }
  for( final o in esp.origenes){
    await txn.insert('Origen', {...o.toMap(),'nombre_cientifico': esp.nombre_cientifico},conflictAlgorithm: ConflictAlgorithm.replace);
  }

  final ok = await _sync.registrarSync(
    tx: txn, id: esp.nombre_cientifico,versionRemota: version
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
           meta = remoteMetaDataCompletaMap[esp.nombre_cientifico];
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
        whereArgs: [esp.nombre_cientifico],
      );
      if(filas == 0) {
        throw Exception('Especie no existe');
      }

      await _borrarVO(txn,esp.nombre_cientifico);
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