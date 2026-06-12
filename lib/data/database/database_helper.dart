// lib/data/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/plant_model.dart';
import '../models/scan_history_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tanaman_detect.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabel users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabel scan_history
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        plant_type TEXT NOT NULL,
        image_path TEXT NOT NULL,
        diagnosis_result TEXT NOT NULL,
        confidence REAL NOT NULL,
        scan_date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabel plants
    await db.execute('''
      CREATE TABLE plants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        plant_type TEXT NOT NULL,
        plant_name TEXT NOT NULL,
        planting_date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add any migration logic here
    }
  }

  // ==================== USER OPERATIONS ====================
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return maps.isNotEmpty ? UserModel.fromMap(maps.first) : null;
  }

  Future<UserModel?> login(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return maps.isNotEmpty ? UserModel.fromMap(maps.first) : null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ==================== SCAN HISTORY OPERATIONS ====================
  Future<int> insertScanHistory(ScanHistoryModel scan) async {
    final db = await database;
    return await db.insert('scan_history', scan.toMap());
  }

  Future<List<ScanHistoryModel>> getScanHistoryByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'scan_date DESC',
    );
    return List.generate(maps.length, (i) => ScanHistoryModel.fromMap(maps[i]));
  }

  Future<int> deleteScanHistory(int id) async {
    final db = await database;
    return await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== PLANT OPERATIONS ====================
  Future<int> insertPlant(PlantModel plant) async {
    final db = await database;
    return await db.insert('plants', plant.toMap());
  }

  Future<List<PlantModel>> getPlantsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'planting_date DESC',
    );
    return List.generate(maps.length, (i) => PlantModel.fromMap(maps[i]));
  }
}
