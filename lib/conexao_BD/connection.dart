import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Connection {
  static final Connection instance = Connection._init();

  static Database? _database;

  Connection._init();

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('biblioteca.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE livros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeLivro TEXT NOT NULL,
      nomeAutor TEXT NOT NULL,
      preco REAL NOT NULL,
      genero TEXT NOT NULL,
      image TEXT,
      isFavorite INTEGER 
    )
    ''');
    await db.execute('''
          CREATE TABLE usuarios(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          NOME TEXT NOME NULL,
          EMAIL TEXT NOT NULL,
          SENHA TEXT NOT NULL,
          CONFIRMASENHA TEXT NOT NULL
          )
          ''');

    await db.execute('''
    CREATE TABLE favorites(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      livroId INTEGER,
      FOREIGN KEY (livroId) REFERENCES biblioteca(id)
    )
    ''');

    await db.execute('''
   
    CREATE TABLE historico_leitura (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bookId INTEGER,
      userId INTEGER,
      dateRead TEXT,
      rating INTEGER,
      review TEXT,
      status TEXT,
      FOREIGN KEY (bookId) REFERENCES livros(id),
      FOREIGN KEY (userId) REFERENCES usuario(id)
  )
   ''');
  }

  Future close() async {
    final db = await instance.database;
    if (db != null) {
      await db.close();
    }
  }
}
