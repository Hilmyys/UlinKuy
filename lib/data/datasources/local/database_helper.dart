import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ulinkuy.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT,
        role TEXT NOT NULL
      )
    ''');

    // Cafes Table (Simplified for local storage)
    await db.execute('''
      CREATE TABLE cafes (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL,
        reviewsCount INTEGER,
        priceRange TEXT,
        wifiSpeed INTEGER,
        crowdLevel REAL,
        tasteRating TEXT,
        tags TEXT, -- JSON string
        facilities TEXT, -- JSON string
        operatingHours TEXT
      )
    ''');
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  Future<void> seedCafes(List<Map<String, dynamic>> cafes) async {
    final db = await instance.database;
    Batch batch = db.batch();
    for (var cafe in cafes) {
      batch.insert('cafes', cafe, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit();
  }
}
