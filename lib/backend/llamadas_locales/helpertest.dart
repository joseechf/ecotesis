import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database; // 🔥 ya NO es static

  final String? customPath;

  DatabaseHelper({this.customPath});

  Future<Database> get instancia async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        customPath ?? join(await getDatabasesPath(), 'flora_database.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // 1. Tabla Flora (completa, igual que producción)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS Flora (
          nombre_cientifico TEXT PRIMARY KEY,
          da_sombra INTEGER CHECK (da_sombra IN (1, 0)),
          flor_distintiva TEXT CHECK (length(flor_distintiva) <= 50),
          fruta_distintiva TEXT CHECK (length(fruta_distintiva) <= 50),
          salud_suelo INTEGER CHECK (salud_suelo IN (1, 0)),
          huespedes TEXT CHECK (huespedes IS NULL OR huespedes IN ('Mono', 'Aves')),
          forma_crecimiento TEXT CHECK (forma_crecimiento IN ('Rapido', 'Lento')),
          pionero INTEGER CHECK (pionero IN (1, 0)),
          polinizador TEXT CHECK (polinizador IN ('Mariposa', 'Abeja', 'Mixto')),
          ambiente TEXT CHECK (ambiente IN ('Seco', 'Humedo', 'Mixto')),
          nativo_america INTEGER CHECK (nativo_america IN (1, 0)),
          nativo_panama INTEGER CHECK (nativo_panama IN (1, 0)),
          nativo_azuero INTEGER CHECK (nativo_azuero IN (1, 0)),
          estrato TEXT CHECK (length(estrato) <= 50)
        )
        ''');

        // 2. Tabla NombreComun (completa, igual que producción)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS NombreComun (
          nombre_comun TEXT CHECK (length(nombre_comun) <= 50) NOT NULL,
          nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
          PRIMARY KEY (nombre_cientifico, nombre_comun),
          FOREIGN KEY (nombre_cientifico)
            REFERENCES Flora(nombre_cientifico)
            ON DELETE CASCADE
        )
        ''');

        // 3. Tabla Utilidad (faltaba en el test anterior)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS Utilidad (
          utilidad TEXT NOT NULL
            CHECK (utilidad IN ('Frutal', 'Maderal', 'Ganado', 'Medicinal')),
          nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
          PRIMARY KEY (nombre_cientifico, utilidad),
          FOREIGN KEY (nombre_cientifico)
            REFERENCES Flora(nombre_cientifico)
            ON DELETE CASCADE
        )
        ''');

        // 4. Tabla Origen (faltaba en el test anterior)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS Origen (
          origen TEXT CHECK (length(origen) <= 50),
          nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
          PRIMARY KEY (origen, nombre_cientifico),
          FOREIGN KEY (nombre_cientifico)
            REFERENCES Flora(nombre_cientifico)
            ON DELETE CASCADE
        )
        ''');

        // 5. Tabla de sincronización (completa, igual que producción)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS sincronizacion (
          id TEXT PRIMARY KEY, 
          is_new INTEGER NOT NULL DEFAULT 0 CHECK (is_new IN (0,1)),
          is_update INTEGER NOT NULL DEFAULT 0 CHECK (is_update IN (0,1)),
          is_delete INTEGER NOT NULL DEFAULT 0 CHECK (is_delete IN (0,1)),
          hash TEXT NOT NULL,
          version INTEGER NOT NULL DEFAULT 1,
          device TEXT,
          last_upd TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        ''');

        // 6. Tabla de última sincronización (opcional para tests)
        await db.execute('''
        CREATE TABLE IF NOT EXISTS ultima_sinc (
          id INTEGER PRIMARY KEY CHECK (id = 1),
          fecha_sincronizacion TEXT NOT NULL,
          registros_locales_procesados TEXT,
          registros_remotos_procesados TEXT
        )
        ''');
      },
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

final dbLocal = DatabaseHelper();
