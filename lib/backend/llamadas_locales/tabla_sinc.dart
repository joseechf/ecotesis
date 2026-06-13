import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/supabase_client.dart';

const String ide = 'id';

class TablaSyncLocal {
  String get correo {
    final session = SupabaseClientSingleton.client.auth.currentSession;
    return session?.user.email ?? '';
  }

  Future<bool> registrarSync({
    required Transaction tx,
    required String id,
    int? versionRemota,
  }) async {

    final existente = await tx.query(
      'sincronizacion',
      where: '$ide = ?',
      whereArgs: [id],
      limit: 1,
    );

    if(existente.isEmpty) {
      try {
        //  nueva fila
        await tx.insert('sincronizacion', {
          'id': id,
          'is_new': 1,
          'is_update': 0,
          'is_delete': 0,
          'version': versionRemota ?? 1,
          'usuario': correo,
          'last_upd': DateTime.now().toUtc().toIso8601String(),
        });
        return true;
      } catch (e) {
        debugPrint('error insert fila en sincronizacion: $e');
        return false;
      }
    } else {
      final versionActual = existente.first['version'] as int? ?? 1;
      try {
        //  update fila existente
        await tx.update('sincronizacion', {
            'id': id,
            'is_new': 0,
            'is_update': 1,
            'is_delete': 0,
            'version': versionRemota ?? versionActual + 1, //si version existe es porque viene de la sincronizacion desde el API, sino se llamo a metadatos desde local
            'usuario': correo,
            'last_upd': DateTime.now().toUtc().toIso8601String(),
          },
          where: '$ide = ?',
          whereArgs: [id],
        );
        return true;
      } catch (e) {
        debugPrint('error insert fila en sincronizacion: $e');
        return false;
      }
    }
  }

  Future<bool> registrarBorrado(Transaction tx, String id,int? versionRemota) async {
  try {
    final existente = await tx.query(
      'sincronizacion',
      where: '$ide = ?',
      whereArgs: [id],
      limit: 1,
    );
    if(existente.isEmpty){
      await tx.insert('sincronizacion', {
          'id': id,
          'is_new': 0,
          'is_update': 0,
          'is_delete': 1,
          'version': versionRemota ?? 1,
          'usuario': correo,
          'last_upd': DateTime.now().toUtc().toIso8601String(),
        });
    } else {
      final versionActual = existente.first['version'] as int? ?? 1;

      await tx.update('sincronizacion', {
            'id': id,
            'is_new': 0,
            'is_update': 0,
            'is_delete': 1,
            'version': versionRemota ?? versionActual + 1,
            'usuario': correo,
            'last_upd': DateTime.now().toUtc().toIso8601String(),
          },
          where: '$ide = ?',
          whereArgs: [id],
        );
      }
      return true;
    } catch (e) {
      debugPrint('error registrarBorrado: $e');
      return false;
    }
  }

  Future<void> limpiarSincronizacion(Database db) async {
    await db.delete('sincronizacion');
  }

  Future<void> guardarUltimaSincronizacion({
    required Database db,
    required String fecha,
    required List<String> idsLoc,
    required List<String> idsRem,
  }) async {
    final datos = {
      'id': 1,
      'fecha_sincronizacion': fecha,
      'registros_locales_procesados': jsonEncode(idsLoc),
      'registros_remotos_procesados': jsonEncode(idsRem),
    };

    await db.insert(
      'ultima_sinc',
      datos,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

