import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'todo_list.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('tasks', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database db = await database;
    return await db.query('tasks');
  }

  Future<Map<String, dynamic>?> queryTask(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateTask(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(
      'tasks',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
