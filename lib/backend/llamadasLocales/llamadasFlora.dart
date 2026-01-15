import '../../frond/baseDatos/models/especie.dart';
import 'package:sqflite/sqflite.dart';
import 'sqliteHelper.dart';
import 'package:flutter/foundation.dart';

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

Future<bool> updateFloraLocal(Especie especie) async {
  final Database db = await dbLocal.instancia;

  try {
    await db.transaction((txn) async {
      /// 1️⃣ UPDATE tabla Flora (solo campos simples)
      final Map<String, Object?> floraUpdate = {};

      void put(String key, Object? value) {
        if (value != null) floraUpdate[key] = value;
      }

      put('daSombra', especie.daSombra);
      put('florDistintiva', especie.florDistintiva);
      put('frutaDistintiva', especie.frutaDistintiva);
      put('saludSuelo', especie.saludSuelo);
      put('huespedes', especie.huespedes);
      put('formaCrecimiento', especie.formaCrecimiento);
      put('pionero', especie.pionero);
      put('polinizador', especie.polinizador);
      put('ambiente', especie.ambiente);
      put('nativoAmerica', especie.nativoAmerica);
      put('nativoPanama', especie.nativoPanama);
      put('nativoAzuero', especie.nativoAzuero);
      put('estrato', especie.estrato);

      if (floraUpdate.isNotEmpty) {
        await txn.update(
          'Flora',
          floraUpdate,
          where: 'nombreCientifico = ?',
          whereArgs: [especie.nombreCientifico],
        );
      }

      /// 2️⃣ NombreComun
      await txn.delete(
        'NombreComun',
        where: 'nombreCientifico = ?',
        whereArgs: [especie.nombreCientifico],
      );

      for (final n in especie.nombresComunes) {
        await txn.insert('NombreComun', {
          'nombreComun': n.nombres,
          'nombreCientifico': especie.nombreCientifico,
        });
      }

      /// 3️⃣ Utilidad
      await txn.delete(
        'Utilidad',
        where: 'nombreCientifico = ?',
        whereArgs: [especie.nombreCientifico],
      );

      for (final u in especie.utilidades) {
        await txn.insert('Utilidad', {
          'utilidad': u.utilpara,
          'nombreCientifico': especie.nombreCientifico,
        });
      }

      /// 4️⃣ Origen
      await txn.delete(
        'Origen',
        where: 'nombreCientifico = ?',
        whereArgs: [especie.nombreCientifico],
      );

      for (final o in especie.origenes) {
        await txn.insert('Origen', {
          'origen': o.origen,
          'nombreCientifico': especie.nombreCientifico,
        });
      }
    });

    return true;
  } catch (e, s) {
    debugPrint('[SQLite] error updateFloraLocal: $e');
    debugPrintStack(stackTrace: s);
    return false;
  }
}
