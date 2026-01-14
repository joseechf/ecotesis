import '../../frond/baseDatos/models/especie.dart';
import 'package:sqflite/sqflite.dart';
import 'sqliteHelper.dart';

Future<List<Map<String, dynamic>>> cargarFloraLocal() async {
  final Database db = await dbLocal.instancia;

  try {
    final List<Map<String, dynamic>> floraRaw = await db.query('Flora');
    if (floraRaw.isEmpty) return [];
    List<Map<String, dynamic>> especiesCompletas = [];

    for (var planta in floraRaw) {
      Map<String, dynamic> filaCompleta = Map<String, dynamic>.from(planta);
      String nombreCientifico = filaCompleta['nombreCientifico'];

      final List<Map<String, dynamic>> nombres = await db.query(
        'NombreComun',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );
      filaCompleta['nombres_comunes'] = nombres;

      final List<Map<String, dynamic>> utilidades = await db.query(
        'Utilidad',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );
      filaCompleta['utilidades'] = utilidades;

      final List<Map<String, dynamic>> origenes = await db.query(
        'Origen',
        where: 'nombreCientifico = ?',
        whereArgs: [nombreCientifico],
      );
      filaCompleta['origenes'] = origenes;

      especiesCompletas.add(filaCompleta);
    }

    return especiesCompletas;
  } catch (e) {
    print('Error al obtener las especies locales: $e');
    return [];
  }
}

Future<bool> insertFloraLocal(List<dynamic> filas) async {
  final Database db = await dbLocal.instancia;

  try {
    await db.transaction((transaccion) async {
      for (var especie in filas) {
        Map<String, dynamic> floraData = Map.from(especie);

        final List<dynamic> nombresComunes =
            floraData.remove('NombreComun') ?? [];
        final List<dynamic> utilidades = floraData.remove('Utilidad') ?? [];
        final List<dynamic> origenes = floraData.remove('Origen') ?? [];
        floraData.remove('Imagen');
        await transaccion.insert(
          'Flora',
          floraData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        final String nombreCientifico = floraData['nombreCientifico'];

        await _insertAuxiliar(
          transaccion: transaccion,
          tabla: 'NombreComun',
          lista: nombresComunes,
          nombreCientifico: nombreCientifico,
        );
        await _insertAuxiliar(
          transaccion: transaccion,
          tabla: 'Utilidad',
          lista: utilidades,
          nombreCientifico: nombreCientifico,
        );
        await _insertAuxiliar(
          transaccion: transaccion,
          tabla: 'Origen',
          lista: origenes,
          nombreCientifico: nombreCientifico,
        );

        print(
          'Procesada especie: $nombreCientifico y sus tablas relacionadas.',
        );
      }
    });

    print('Transacción completada con éxito.');
    return true;
  } catch (e) {
    print('Error en la transacción de inserción masiva: $e');
    return false;
  }
}

Future<void> _insertAuxiliar({
  required Transaction transaccion,
  required String tabla,
  required List<dynamic> lista,
  required String nombreCientifico,
}) async {
  if (lista.isEmpty) return;

  for (var item in lista) {
    Map<String, dynamic> filaParaInsertar = {
      'nombreCientifico': nombreCientifico,
    };

    switch (tabla) {
      case 'NombreComun':
        filaParaInsertar['nombreComun'] = item['nombres'];
        break;

      case 'Utilidad':
        filaParaInsertar['utilidad'] = item['utilpara'];
        break;

      case 'Origen':
        filaParaInsertar['origen'] = item['origen'];
        break;

      default:
        filaParaInsertar.addAll(Map<String, dynamic>.from(item));
    }

    await transaccion.delete(
      tabla,
      where: 'nombreCientifico = ?',
      whereArgs: [nombreCientifico],
    );

    await transaccion.insert(
      tabla,
      filaParaInsertar,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
