import '../../../backend/llamadas_locales/sqlite_helper.dart';
import 'package:flutter/foundation.dart';

Future<void> limpiarHuerfanos() async {
  final db = await dbLocal.instancia;

  await db.transaction((tx) async {
    final resultado = await tx.rawQuery('''
      SELECT s.id
      FROM sincronizacion s
      LEFT JOIN Flora f
        ON f.nombre_cientifico = s.id
      WHERE f.nombre_cientifico IS NULL
    ''');

    for (final fila in resultado) {
      final id = fila['id'] as String;

      await tx.delete('sincronizacion', where: 'id = ?', whereArgs: [id]);

      debugPrint(' Huérfano eliminado: $id');
    }
  });
}
