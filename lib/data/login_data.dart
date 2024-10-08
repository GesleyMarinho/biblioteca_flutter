import 'package:biblioteca_flutter/conexao_BD/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblioteca_flutter/model/login_model.dart';
import 'package:sqflite/sqflite.dart';

class LoginData {
  static final LoginData instace = LoginData._init();
  static Database? _database;

  LoginData._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await Connection.instance.database;
    return _database!;
  }

  Future<void> insertUsuario(LoginModel usuario) async {
    final db = await instace.database;
    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future nomeUsuario(int userId) async {
    final db = await instace.database;
    final List<Map<String, dynamic>> users =
        await db.query('usuarios', where: 'id= ?', whereArgs: [userId]);

    if (users.isNotEmpty) {
      return users.first['NOME'] ??
          'Nome não disponível'; // Altere 'nome' para o nome da coluna que armazena o nome do usuário
    } else {
      return 'Usuário não encontrado'; // Ou outra mensagem padrão
    }
  }

  Future<bool> auteticacaoUsuario(LoginModel usuario) async {
    final Database db = await instace.database;
    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'email = ? and senha = ?',
      whereArgs: [usuario.email, usuario.senha],
    );
    //return result.isNotEmpty;
    if (result.isNotEmpty) {
      // Aqui, salvamos o ID do usuário autenticado
      int userId = result.first['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId); // Salvando o ID
      return true;
    }
    return false;
  }
}
