import 'package:sqflite/sqflite.dart';
import '../libSinc/utilidades/calcularHash.dart';
import 'sqliteHelper.dart';
import 'package:flutter/foundation.dart';

class TablaSyncLocal {
  Future<List<Map<String, dynamic>>> obtenerPendientes() async {
    final Database db = await dbLocal.instancia;
    return await db.query('sincronizacion');
  }

  Future<bool> registrarSync({
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
      try {
        // INSERT nuevo
        await tx.insert('sincronizacion', {
          'id': id,
          'is_new': 1,
          'is_update': 0,
          'is_delete': 0,
          'hash': hash,
          'version': 1,
          'device': device,
          'last_upd': DateTime.now().toIso8601String(),
        });
        debugPrint('metadatos sinc local insert ok');
        return true;
      } catch (e) {
        debugPrint(' insert sinc error: $e');
        return false;
      }
    } else {
      // UPDATE existente
      final versionActual = existente.first['version'] as int? ?? 1;
      try {
        await tx.update(
          'sincronizacion',
          {
            'is_new': 0,
            'is_update': 1,
            'is_delete': 0,
            'hash': hash,
            'version': versionActual + 1,
            'device': device,
            'last_upd': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [id],
        );
        debugPrint('metadatos sinc local update ok');
        return true;
      } catch (e) {
        debugPrint(' update sinc error: $e');
        return false;
      }
    }
  }

  Future<bool> registrarUpsert(
    Transaction tx,
    String id,
    Map<String, dynamic> fila,
  ) async {
    try {
      await registrarSync(tx: tx, id: id, fila: fila, device: 'mobile');
      debugPrint('metadatos sinc local registro ok');
      return true;
    } catch (e) {
      debugPrint(' registro upsert error: $e');
      return false;
    }
  }

  Future<bool> registrarBorrado(Transaction tx, String id) async {
    try {
      await tx.insert('sincronizacion', {
        'id': id,
        'is_new': 0,
        'is_update': 0,
        'is_delete': 1,
        'hash': '',
        'version': 1,
        'device': 'mobile',
        'last_upd': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('metadatos sinc local softdelete ok');
      return true;
    } catch (e) {
      debugPrint(' registro upsert error: $e');
      return false;
    }
  }

  Future<void> limpiarSincronizacion(Database db) async {
    await db.delete('sincronizacion');
  }
}
