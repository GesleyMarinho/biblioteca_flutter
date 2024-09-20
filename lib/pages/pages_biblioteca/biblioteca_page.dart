import 'package:biblioteca_flutter/data/login_data.dart';
import 'package:biblioteca_flutter/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages_login/login_page.dart';

class BibliotecaPage extends StatefulWidget {
  const BibliotecaPage({super.key});

  @override
  State<BibliotecaPage> createState() => _BibliotecaPageState();
}

class _BibliotecaPageState extends State<BibliotecaPage> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _buscarNomeUser();
  }



  // Método para buscar o nome
  Future<void> _buscarNomeUser() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if(userId != null) {
      String userName = await LoginData.instace.nomeUsuario(userId);

      setState(() {
        _userName = userName;
      });
    }else{
      setState(() {
        _userName = 'Null';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Meus Livros',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), // Adicionando const aqui
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Drawer(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blueAccent,
              child: Text(
                'Menu - $_userName',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Register'),
              onTap: () {
                // Redireciona para a página de inserção
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                // Redireciona para a página de edição
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Redireciona para a página de exclusão
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('List'),
              onTap: () {
                // Redireciona para a página de listagem
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favoritos'),
              onTap: () {
                // Redireciona para a página de favoritos
              },
            ),
          ],
        ),
      ),
    );
  }
}
