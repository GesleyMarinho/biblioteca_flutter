import 'package:sqflite/sqflite.dart';

import '../conexao_BD/connection.dart';
import '../model/biblioteca_model.dart';

class LivroData {
  static final LivroData instance = LivroData._init();

  static Database? _database;

  LivroData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.instance.database;
    return _database!;
  }

  Future<List<int>> getLivroEmLeitura() async {
    final db = await instance.database;
    final result = await db.query('historico_leitura');
    return result.map((e) => e['bookId'] as int).toList();
  }

  Future<void> toggleLivroEmLeitura(BibliotecaModel livro) async {
    final db = await instance.database;
    final livroEmLeitura = await db.query('historico_leitura',
        where: 'bookId = ?', whereArgs: [livro.id]);

    if (livroEmLeitura.isEmpty) {
      await db.insert(
        'historico_leitura',
        {'bookId': livro.id},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.delete(
        'historico_leitura',
        where: 'bookId = ?',
        whereArgs: [livro.id],
      );
    }
  }
}
