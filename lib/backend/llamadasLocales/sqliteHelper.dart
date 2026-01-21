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
      nombre_cientifico TEXT PRIMARY KEY,
      da_sombra INTEGER CHECK (da_sombra IN (1, 0)),
      flor_distintiva TEXT,
      fruta_distintiva TEXT,
      salud_suelo INTEGER CHECK (salud_suelo IN (1, 0)),
      huespedes TEXT CHECK (huespedes IS NULL OR huespedes IN ('Mono', 'Aves')),
      forma_crecimiento TEXT CHECK (forma_crecimiento IN ('Rapido', 'Lento')),
      pionero INTEGER CHECK (pionero IN (1, 0)),
      polinizador TEXT CHECK (polinizador IN ('Mariposa', 'Abeja', 'Mixto')),
      ambiente TEXT CHECK (ambiente IN ('Seco', 'Humedo', 'Mixto')),
      nativo_america INTEGER CHECK (nativo_america IN (1, 0)),
      nativo_panama INTEGER CHECK (nativo_panama IN (1, 0)),
      nativo_azuero INTEGER CHECK (nativo_azuero IN (1, 0)),
      estrato TEXT
    )
  ''');

        // 2. Tabla NombreComun
        await db.execute('''
    CREATE TABLE NombreComun (
      nombre_comun TEXT NOT NULL,
      nombre_cientifico TEXT NOT NULL,
      PRIMARY KEY (nombre_cientifico, nombre_comun),
      FOREIGN KEY (nombre_cientifico)
        REFERENCES Flora(nombre_cientifico)
        ON DELETE CASCADE
    )
  ''');

        // 3. Tabla Utilidad
        await db.execute('''
    CREATE TABLE Utilidad (
      utilidad TEXT NOT NULL
        CHECK (utilidad IN ('Frutal', 'Maderal', 'Ganado', 'Medicinal')),
      nombre_cientifico TEXT NOT NULL,
      PRIMARY KEY (nombre_cientifico, utilidad),
      FOREIGN KEY (nombre_cientifico)
        REFERENCES Flora(nombre_cientifico)
        ON DELETE CASCADE
    )
  ''');

        // 4. Tabla Origen
        await db.execute('''
    CREATE TABLE Origen (
      origen TEXT,
      nombre_cientifico TEXT NOT NULL,
      PRIMARY KEY (origen, nombre_cientifico),
      FOREIGN KEY (nombre_cientifico)
        REFERENCES Flora(nombre_cientifico)
        ON DELETE CASCADE
    )
  ''');

        // 5. Tabla de sincronización
        await db.execute('''
    CREATE TABLE sincronizacion (
      id TEXT PRIMARY KEY, -- nombre_cientifico
      is_new INTEGER,
      is_update INTEGER,
      is_delete INTEGER,
      hash TEXT,
      version INTEGER,
      device TEXT,
      last_upd TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''');

        // 6. Tabla de última sincronización
        await db.execute('''
    CREATE TABLE ultima_sinc (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      fecha_sincronizacion TEXT NOT NULL,
      registros_locales_procesados TEXT, -- JSON array de strings
      registros_remotos_procesados TEXT  -- JSON array de strings
    )
  ''');
      },
    );
  }
}

final dbLocal = DatabaseHelper();
