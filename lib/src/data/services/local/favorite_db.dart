import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/favorite_model.dart';

class FavoriteDb {
  FavoriteDb._internal();
  static final FavoriteDb instance = FavoriteDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'cryptotrack_favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        crypto_id TEXT NOT NULL,
        name TEXT NOT NULL,
        symbol TEXT NOT NULL,
        current_price REAL NOT NULL,
        price_change_24h REAL NOT NULL,
        price_change_percentage_24h REAL NOT NULL,
        image_url TEXT NOT NULL,
        UNIQUE(user_id, crypto_id)
      );
    ''');
  }

  // =============== MÉTODOS =================

  Future<List<FavoriteModel>> getFavoritesByUser(int userId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );

    return result.map((m) => FavoriteModel.fromMap(m)).toList();
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    final db = await database;
    await db.insert(
      'favorites',
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFavorite(int userId, String cryptoId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND crypto_id = ?',
      whereArgs: [userId, cryptoId],
    );
  }

  Future<bool> isFavorite(int userId, String cryptoId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ? AND crypto_id = ?',
      whereArgs: [userId, cryptoId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
