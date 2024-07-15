import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:sqflite/sqflite.dart';
import '../conexao_BD/connection.dart';

class FavoritesData {

  static final FavoritesData instance = FavoritesData._init();

  static Database? _database;

  FavoritesData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.get(); // Use a conexão unificada
    return _database!;
  }

  Future<void> insertFavorite(BibliotecaModel livro ) async{
    final db = await instance.database;
    await db.insert (
      'favorites',
      livro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<void> deleteFavorite(int id) async{
    final db = await instance.database;
    await db.delete('favorites',where: 'id = ?',whereArgs: [id]);
  }

  Future<List<BibliotecaModel>> getFavorites() async {
    final db = await instance.database;
    final List<Map<String,dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i){
      return BibliotecaModel.fromJson(maps[i]);
    });
  }


}