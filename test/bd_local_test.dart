import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import 'package:ecoazuero/backend/llamadas_locales/helpertest.dart';
import 'package:ecoazuero/backend/llamadas_locales/llamadas_flora.dart';
import 'package:ecoazuero/domain/entities/especie_unificada.dart';
import 'package:ecoazuero/domain/value_objects.dart';

void main() {
  late Database db;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final helper = DatabaseHelper(customPath: inMemoryDatabasePath);
    db = await helper.instancia;
  });

  tearDown(() async {
    await db.close();
  });

  group('🔒 SEGURIDAD', () {
    test('Inyección SQL neutralizada', () async {
      // Setup
      await insertFloraLocal(db, [
        Especie(nombreCientifico: 'victima', polinizador: 'Abeja'),
      ]);

      // Intento de inyección en SELECT
      final ataque1 = await obtenerFloraLocalById(db, "' OR '1'='1");
      expect(ataque1, null);

      // Intento de inyección en INSERT (campo con constraint)
      final ataque2 = await insertFloraLocal(db, [
        Especie(
          nombreCientifico: 'hacker',
          polinizador: "'; DROP TABLE Flora; --",
        ),
      ]);
      expect(ataque2, false);

      // Intento de inyección en UPDATE
      await insertFloraLocal(db, [
        Especie(nombreCientifico: 'atacante', polinizador: 'Mariposa'),
      ]);
      final ataque3 = await updateFloraLocal(
        db,
        Especie(
          nombreCientifico: 'atacante',
          polinizador:
              "'; UPDATE Flora SET polinizador = 'Hackeado' WHERE nombre_cientifico = 'victima'; --",
        ),
      );
      expect(ataque3, false);

      // Verificación: víctima intacta, tabla existe
      final victima = await obtenerFloraLocalById(db, 'victima');
      expect(victima!['polinizador'], 'Abeja');
      expect(await cargarFloraLocal(db), isNotEmpty);
    });

    test('Constraints de datos rechazan valores inválidos', () async {
      // Enum inválido
      final enumInvalido = await insertFloraLocal(db, [
        Especie(nombreCientifico: 'p1', polinizador: 'Hacker'),
      ]);
      expect(enumInvalido, false);

      // Booleano inválido
      final boolInvalido = await insertFloraLocal(db, [
        Especie(nombreCientifico: 'p2', polinizador: 'Abeja', daSombra: 999),
      ]);
      expect(boolInvalido, false);

      // String muy largo
      final longitudInvalida = await insertFloraLocal(db, [
        Especie(
          nombreCientifico: 'p3',
          polinizador: 'Abeja',
          estrato: 'A' * 100,
        ),
      ]);
      expect(longitudInvalida, false);

      // Valores válidos
      final valido = await insertFloraLocal(db, [
        Especie(nombreCientifico: 'valido', polinizador: 'Abeja', daSombra: 1),
      ]);
      expect(valido, true);
    });

    test('Concurrencia sin corrupción de datos', () async {
      // Múltiples inserts del mismo ID
      final especie = Especie(nombreCientifico: 'misma', polinizador: 'Abeja');
      final futures = List.generate(10, (_) => insertFloraLocal(db, [especie]));
      await Future.wait(futures);

      // Solo debe existir 1 registro
      final resultado = await cargarFloraLocal(db);
      expect(resultado.length, 1);

      // Operaciones cruzadas simultáneas
      await Future.wait([
        insertFloraLocal(db, [
          Especie(nombreCientifico: 'nueva', polinizador: 'Mixto'),
        ]),
        updateFloraLocal(
          db,
          Especie(nombreCientifico: 'misma', polinizador: 'Mariposa'),
        ),
        cargarFloraLocal(db),
      ]);

      // Datos consistentes
      final finalCheck = await cargarFloraLocal(db);
      expect(finalCheck.length, 2);
    });

    test('Lógica de negocio robusta', () async {
      // Update de inexistente falla
      final updateFantasma = await updateFloraLocal(
        db,
        Especie(nombreCientifico: 'no_existe', polinizador: 'Abeja'),
      );
      expect(updateFantasma, false);

      // Delete de inexistente falla
      final deleteFantasma = await deleteFloraLocal(db, 'tampoco_existe');
      expect(deleteFantasma, false);

      // FK sin padre falla
      expect(
        () => db.insert('NombreComun', {
          'nombre_comun': 'Huerfano',
          'nombre_cientifico': 'sin_padre',
        }),
        throwsA(isA<Exception>()),
      );

      // Límite de recursos (50 nombres máximo)
      expect(() {
        Especie(
          nombreCientifico: 'exceso',
          polinizador: 'Abeja',
          nombresComunes: List.generate(
            51,
            (i) => NombreComun(nombreComun: 'N$i'),
          ),
        );
      }, throwsA(isA<AssertionError>()));
    });
  });
}
