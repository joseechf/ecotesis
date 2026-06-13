import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get instancia async {
    if(_database != null) return _database!;
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
        await db.execute( ''' 
          CREATE TABLE IF NOT EXISTS Flora (
            nombre_cientifico TEXT PRIMARY KEY,
            da_sombra INTEGER CHECK (da_sombra IN (1,0)),
            flor_distintiva TEXT CHECK (length(flor_distintiva) <= 50),
            fruta_distintiva TEXT CHECK (length(fruta_distintiva)<= 50),
            salud_suelo INTEGER CHECK (salud_suelo IN (1,0)),
            huespedes TEXT CHECK (huespedes IS NULL OR huespedes IN ('Mono', 'Aves')),
            forma_crecimiento TEXT CHECK (forma_crecimiento IN ('Rapido','Lento')),
            pionero INTEGER CHECK (pionero IN (1,0)),
            polinizador TEXT CHECK (polinizador IN ('Mariposa','Abeja','Mixto')),
            ambiente TEXT CHECK (ambiente IN ('Seco','Humedo','Mixto')),
            establecido_sol_sombra TEXT CHECK (establecido_sol_sombra IN ('Sol','Sombra','Mixto')),
            nativo_america INTEGER CHECK (nativo_america IN (1,0)),
            nativo_panama INTEGER CHECK (nativo_panama IN (1,0)),
            nativo_azuero INTEGER CHECK (nativo_azuero IN (1,0)),
            estrato TEXT CHECK (length(estrato) <= 50),
            cobertura REAL default 0 CHECK (cobertura >= 0) not null
          )
        ''');
        await db.execute(''' 
          CREATE TABLE IF NOT EXISTS NombreComun (
            nombre_comun TEXT CHECK (length(nombre_comun) <= 50),
            nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
            PRIMARY KEY (nombre_cientifico, nombre_comun),
            FOREIGN KEY (nombre_cientifico) REFERENCES Flora(nombre_cientifico) ON DELETE CASCADE
          )
        ''');
        await db.execute(''' 
          CREATE TABLE IF NOT EXISTS Utilidad (
            utilidad TEXT CHECK (utilidad IN ('Frutal','Maderal','Ganado','Medicinal')),
            nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
            PRIMARY KEY (nombre_cientifico, utilidad),
            FOREIGN KEY (nombre_cientifico) REFERENCES Flora(nombre_cientifico) ON DELETE CASCADE
          )
        ''');
        await db.execute(''' 
          CREATE TABLE IF NOT EXISTS Origen (
            origen TEXT CHECK (length(origen) <= 50),
            nombre_cientifico TEXT CHECK (length(nombre_cientifico) <= 50) NOT NULL,
            PRIMARY KEY (nombre_cientifico, origen),
            FOREIGN KEY (nombre_cientifico) REFERENCES Flora(nombre_cientifico) ON DELETE CASCADE
          )
        ''');
        await db.execute(''' 
          CREATE TABLE IF NOT EXISTS sincronizacion (
            id TEXT PRIMARY KEY,
            is_new INTEGER NOT NULL DEFAULT 0 CHECK (is_new IN (0,1)),
            is_update INTEGER NOT NULL DEFAULT 0 CHECK (is_update IN (0,1)),
            is_delete INTEGER NOT NULL DEFAULT 0 CHECK (is_delete IN (0,1)),
            version INTEGER NOT NULL DEFAULT 1 CHECK (version >= 1),
            usuario TEXT NOT NULL CHECK (
              length(usuario) <= 100 AND usuario LIKE '%@%.%' AND 
              instr(usuario, ' ') = 0
            ),
            last_upd TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        ''');
        await db.execute(''' 
          CREATE TABLE IF NOT EXISTS ultima_sinc (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            fecha_sincronizacion TEXT NOT NULL,
            registros_locales_procesados TEXT, -- JSON array de strings
            registros_remotos_procesados TEXT -- JSON array de strings
          )
        ''');
      }
    );
  }
}

final dbLocal = DatabaseHelper();