import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:sqflite/sqflite.dart';
import '../conexao_BD/connection.dart';

class FavoritesData {
  static final FavoritesData instance = FavoritesData._init();

  static Database? _database;

  FavoritesData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.instance.database;
    return _database!;
  }

  Future<void> toggleFavorite(BibliotecaModel livro) async {
    final db = await instance.database;
    final favorites = await db
        .query('favorites', where: 'livroId = ?', whereArgs: [livro.id]);

    if (favorites.isEmpty) {
      await db.insert(
        'favorites',
        {'livroId': livro.id},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.delete('favorites', where: 'livroId = ?', whereArgs: [livro.id]);
    }
  }

  Future<List<int>> getFavoriteIds() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return maps[i]['livroId'];
    });
  }

  Future<List<BibliotecaModel>> getFavorites() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT *
      FROM livros 
      INNER JOIN favorites ON livros.id = favorites.livroId
    ''');

    return List.generate(maps.length, (i) {
      return BibliotecaModel.fromJson(maps[i]);
    });
  }

  Future<void> dataInicioLeitura(int bookId, DateTime data) async {
    final db = await instance.database;

    await db.rawInsert(
      '''INSERT INTO historico_leitura (bookId, dataRead) VALUES (?, ?)
         ON CONFLICT(bookId) DO UPDATE SET dataRead = excluded.dataRead''',
      [bookId, data.toIso8601String()],
    );
  }
}
