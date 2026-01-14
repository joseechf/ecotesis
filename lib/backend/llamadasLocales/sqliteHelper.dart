import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get instancia async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'flora_database.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // 1. Tabla Flora
        await db.execute('''
        CREATE TABLE Flora (
          nombreCientifico TEXT PRIMARY KEY,
          daSombra INTEGER CHECK (daSombra IN (1, 0)),
          florDistintiva TEXT,
          frutaDistintiva TEXT,
          saludSuelo INTEGER CHECK (saludSuelo IN (1, 0)),
          huespedes TEXT CHECK (huespedes IS NULL OR huespedes IN ('Mono', 'Aves')),
          formaCrecimiento TEXT CHECK (formaCrecimiento IN ('Rapido', 'Lento')),
          pionero INTEGER CHECK (pionero IN (1, 0)),
          polinizador TEXT CHECK (polinizador IN ('Mariposa', 'Abeja', 'Mixto')),
          ambiente TEXT CHECK (ambiente IN ('Seco', 'Humedo', 'Mixto')),
          nativoAmerica INTEGER CHECK (nativoAmerica IN (1, 0)),
          nativoPanama INTEGER CHECK (nativoPanama IN (1, 0)),
          nativoAzuero INTEGER CHECK (nativoAzuero IN (1, 0)),
          estrato TEXT
        )
      ''');

        // 2. Tabla NombreComun
        await db.execute('''
        CREATE TABLE NombreComun (
          nombreComun TEXT NOT NULL UNIQUE,
          nombreCientifico TEXT NOT NULL,
          PRIMARY KEY(nombreCientifico, nombreComun),
          FOREIGN KEY(nombreCientifico) REFERENCES Flora(nombreCientifico) ON DELETE CASCADE
        )
      ''');

        // 3. Tabla Utilidad
        await db.execute('''
        CREATE TABLE Utilidad (
          utilidad TEXT NOT NULL CHECK (utilidad IN ('Frutal', 'Maderal', 'Ganado', 'Medicinal')),
          nombreCientifico TEXT NOT NULL,
          PRIMARY KEY(nombreCientifico, utilidad),
          FOREIGN KEY(nombreCientifico) REFERENCES Flora(nombreCientifico) ON DELETE CASCADE
        )
      ''');

        // 4. Tabla Origen
        await db.execute('''
        CREATE TABLE Origen (
          origen TEXT,
          nombreCientifico TEXT NOT NULL,
          PRIMARY KEY(origen, nombreCientifico),
          FOREIGN KEY (nombreCientifico) REFERENCES Flora(nombreCientifico) ON DELETE CASCADE
        )
      ''');
      },
    );
  }
}

final dbLocal = DatabaseHelper();
