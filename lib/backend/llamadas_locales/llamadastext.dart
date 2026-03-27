/*
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generarHash(Map<String, dynamic> data) {
  final jsonStr = jsonEncode(data);
  return sha256.convert(utf8.encode(jsonStr)).toString();
}

Future<bool> insertFloraLocal(Database db, Map<String, dynamic> data) async {
  try {
    await db.insert('Flora', data);

    await db.insert('sincronizacion', {
      'id': data['nombre_cientifico'],
      'hash': generarHash(data),
      'version': 1,
      'is_delete': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return true;
  } catch (e) {
    return false;
  }
}

Future<List<Map<String, dynamic>>> cargarFloraLocal(Database db) async {
  return await db.query('Flora');
}

Future<Map<String, dynamic>?> obtenerFloraLocalById(
  Database db,
  String id,
) async {
  final res = await db.query(
    'Flora',
    where: 'nombre_cientifico = ?',
    whereArgs: [id],
  );
  return res.isEmpty ? null : res.first;
}

Future<bool> updateFloraLocal(Database db, Map<String, dynamic> data) async {
  try {
    final filas = await db.update(
      'Flora',
      data,
      where: 'nombre_cientifico = ?',
      whereArgs: [data['nombre_cientifico']],
    );

    if (filas == 0) return false;

    await db.update(
      'sincronizacion',
      {'hash': generarHash(data)},
      where: 'id = ?',
      whereArgs: [data['nombre_cientifico']],
    );

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteFloraLocal(Database db, String id) async {
  try {
    final filas = await db.delete(
      'Flora',
      where: 'nombre_cientifico = ?',
      whereArgs: [id],
    );

    return filas > 0;
  } catch (e) {
    return false;
  }
}

Future<bool> softDeleteLocal(Database db, String id) async {
  try {
    await db.insert('sincronizacion', {
      'id': id,
      'hash': '',
      'version': 1,
      'is_delete': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return true;
  } catch (e) {
    return false;
  }
}
*/
