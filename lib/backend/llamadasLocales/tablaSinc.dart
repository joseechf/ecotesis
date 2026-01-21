import 'package:sqflite/sqflite.dart';
import '../libSinc/utilidades/calcularHash.dart';
import 'sqliteHelper.dart';

class TablaSyncLocal {
  Future<List<Map<String, dynamic>>> obtenerPorTabla(String tabla) async {
    final Database db = await dbLocal.instancia;
    return await db.query(
      'sincronizacion',
      where: 'tabla = ?',
      whereArgs: [tabla],
    );
  }

  //por cada cambio se registran los metadatos en la tabla de sincronizacion
  Future<void> registrarSync({
    required Transaction tx,
    required String id,
    required Map<String, Object?> fila,
    required String device,
  }) async {
    final hash = calcularHash(fila);

    final existente = await tx.query(
      'sincronizacion',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (existente.isEmpty) {
      // nuevo
      await tx.insert('sincronizacion', {
        'id': id,
        'isNew': 1,
        'isUpdate': 0,
        'isDelete': 0,
        'hash': hash,
        'version': 1,
        'device': device,
        'TIMESTAMP': DateTime.now().toIso8601String(),
      });
    } else {
      // actualización
      final versionActual = existente.first['version'] as int? ?? 1;

      await tx.update(
        'sincronizacion',
        {
          'isNew': 0,
          'isUpdate': 1,
          'hash': hash,
          'version': versionActual + 1,
          'device': device,
          'TIMESTAMP': DateTime.now().toIso8601String(),
        },
        where: 'id = ? ',
        whereArgs: [id],
      );
    }
  }

  Future<void> registrarUpsert(
    Transaction tx,
    String tabla,
    String id,
    Map<String, dynamic> fila,
  ) async {
    await registrarSync(tx: tx, id: id, fila: fila, device: 'mobile');
  }

  Future<void> registrarBorrado(Transaction tx, String tabla, String id) async {
    await tx.insert('sincronizacion', {
      'id': id,
      'isNew': 0,
      'isUpdate': 0,
      'isDelete': 1,
      'hash': '',
      'version': 1,
      'device': 'mobile',
      'TIMESTAMP': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
