// File: lib/database/database_helper.dart

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'saverfavor.db';
  static const _dbVersion = 1;
  static const _tableHistory = 'history';
  static Database? _instance;

  DatabaseHelper._();
  static Future<Database> get instance async {
    if (_instance != null) return _instance!;
    // Initialize DB
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, _dbName);
    _instance = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableHistory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT NOT NULL,
            visited_at TEXT NOT NULL
          )
        ''');
      },
    );
    return _instance!;
  }

  /// Insert a URL visit record
  static Future<void> insertUrl(String url) async {
    final db = await instance;
    await db.insert(
      _tableHistory,
      {
        'url': url,
        'visited_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all history rows, newest first
  static Future<List<Map<String, dynamic>>> fetchHistory() async {
    final db = await instance;
    return db.query(
      _tableHistory,
      orderBy: 'visited_at DESC',
    );
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    final db = await instance;
    await db.delete(_tableHistory);
  }
}
