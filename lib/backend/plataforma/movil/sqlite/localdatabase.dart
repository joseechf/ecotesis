/*
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../utilidades/item.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _iniciarDB('local_db.db');
    return _database!;
  }

  Future<Database> _iniciarDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _crearDB);
  }

  Future _crearDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE flora (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        tipo TEXT NOT NULL,
        ultAct TEXT NOT NULL,
        sincronizado INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await instance.database;
    return await db.insert('flora', item.toMap());
  }

  Future<List<Item>> getNosincronizado() async {
    final db = await instance.database;
    final maps = await db.query('flora', where: 'sincronizado = ?', whereArgs: [0]);

    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

  Future<List<Item>> getId() async {
    final db = await instance.database;
    final maps = await db.query('flora',columns: ['id']);

    return List.generate(maps.length, (i) => Item.fromMap(maps[i]));
  }

  Future<List<Map<String,dynamic>>> getTabla() async {
    final db = await instance.database;
    return await db.query('flora');
  }

  Future<void> marcaSincronizado(String id) async {
    final db = await instance.database;
    await db.update('flora', {'sincronizado': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
*/
