import 'package:sqflite/sqflite.dart';
import '../utilidades/calcular_hash.dart';
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
    required Map<String, Object?> fila,
  }) async {
    final hash = calcularHash(fila);

    final existente = await tx.query(
      'sincronizacion',
      where: '$ide = ?',
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
          'usuario': correo,
          'last_upd': DateTime.now().toUtc().toIso8601String(),
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
            'last_upd': DateTime.now().toUtc().toIso8601String(),
          },
          where: '$ide = ?',
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

  Future<bool> registrarBorrado(Transaction tx, String id) async {
    try {
      final existente = await tx.query(
        'sincronizacion',
        where: '$ide = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (existente.isEmpty) {
        await tx.insert('sincronizacion', {
          'id': id,
          'is_new': 0,
          'is_update': 0,
          'is_delete': 1,
          'hash': '',
          'version': 1,
          'usuario': correo,
          'last_upd': DateTime.now().toUtc().toIso8601String(),
        });
      } else {
        final versionActual = existente.first['version'] as int? ?? 1;

        await tx.update(
          'sincronizacion',
          {
            'is_new': 0,
            'is_update': 0,
            'is_delete': 1,
            'hash': '',
            'version': versionActual + 1,
            'usuario': correo,
            'last_upd': DateTime.now().toUtc().toIso8601String(),
          },
          where: '$ide = ?',
          whereArgs: [id],
        );
      }

      debugPrint('metadatos sinc local delete ok');
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
