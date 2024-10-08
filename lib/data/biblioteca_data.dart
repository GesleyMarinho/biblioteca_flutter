import 'package:biblioteca_flutter/conexao_BD/connection.dart';
import 'package:sqflite/sqflite.dart';

import '../model/biblioteca_model.dart';

class BibliotecaDatabase {
  static final BibliotecaDatabase instance = BibliotecaDatabase._init();

  static Database? _database;

  BibliotecaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.instance.database; // Use a conexão unificada
    return _database!;
  }

  Future<void> insertLivro(BibliotecaModel livro) async {
    final db = await instance.database;
    await db.insert(
      'livros',
      livro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLivro(BibliotecaModel livro) async {
    final db = await instance.database;

    await db.update(
      'livros',
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  Future<void> deleteLivro(int id) async {
    final db = await instance.database;
    await db.delete(
      'livros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BibliotecaModel>> getLivrosByGenero(String genero) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'livros',
      where: 'genero = ?',
      whereArgs: [genero],
    );

    print('get livros by genero $maps');
    return List.generate(maps.length, (i) {
      return BibliotecaModel.fromJson(maps[i]);
    });
  }

  Future<List<String>> getBuscarGeneros() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT distinct genero FROM livros');
    print('result $result');
    return result.map((e) => e['genero'] as String).toList();
  }

  Future<List<BibliotecaModel>> getLivros() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('livros');

    return List.generate(maps.length, (i) {
      return BibliotecaModel(
        id: maps[i]['id'],
        nomeLivro: maps[i]['nomeLivro'],
        nomeAutor: maps[i]['nomeAutor'],
        preco: maps[i]['preco'],
        genero: maps[i]['genero'],
        image: maps[i]['image'],
        comentario: maps[i]['comentario'],
      );
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
