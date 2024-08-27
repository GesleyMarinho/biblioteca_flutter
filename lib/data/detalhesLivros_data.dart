import 'package:sqflite/sqflite.dart';

import '../conexao_BD/connection.dart';

class DetalheslivrosData {
  static final DetalheslivrosData instance = DetalheslivrosData._init();

  static Database? _database;

  DetalheslivrosData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.instance.database;
    return _database!;
  }

  //atualizando as estrelas do livros;
  Future<void> updateRating(int bookId, double rating) async {
    final db = await instance.database;
    try {
      await db.rawUpdate(
        '''INSERT OR REPLACE INTO historico_leitura (bookId, rating) VALUES (?, ?)''',
        [bookId, rating],
      );
      print('Rating updated: bookId=$bookId, rating=$rating');
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
