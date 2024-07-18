import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Connection {
  static Database? _db;

  static Future<Database> get() async {
    if (_db == null) {
      _db = await openDatabase(
        join(await getDatabasesPath(), 'BD_biblioteca.db'),
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE livros (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nomeLivro TEXT NOT NULL,
              nomeAutor TEXT NOT NULL,
              preco REAL NOT NULL,
              image TEXT,
              genero TEXT NOT NULL
            )
            ''');

          await db.execute('''
            CREATE TABLE usuarios (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              email TEXT NOT NULL,
              senha TEXT NOT NULL,
              confirmasenha TEXT NOT NULL
            )
            ''');

          await db.execute('''
            CREATE TABLE favorites (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nomeLivro TEXT NOT NULL,
              nomeAutor TEXT NOT NULL,
              preco REAL NOT NULL,
              image TEXT,
              genero TEXT NOT NULL,
              favorito int 
            )
            ''');
        },
        version: 1,
      );
    }
    return _db!;
  }

  static Future close() async {
    final db = await _db;
    if (db != null) {
      await db.close();
    }
  }
}
