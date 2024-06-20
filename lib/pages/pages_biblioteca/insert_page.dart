import 'package:biblioteca_flutter/conexao_BD/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class InsertPage extends StatelessWidget {
  InsertPage({super.key});

  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController nomeAutorController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Biblioteca de Livros',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nomeLivroController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'Nome do Livro',
                  hintText: 'As aventuras....',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: const Icon(
                    Icons.local_library,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: nomeAutorController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'Autor',
                  hintText: 'Dom Casmuro....',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: precoController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: 'Preço',
                  hintText: 'R\$....',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: const Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _insertButtonPress(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Cor de fundo do botão
                  padding: const EdgeInsets.all(16.0), // Preenchimento interno
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Borda arredondada
                  ),
                  elevation: 4.0, // Elevação do botão
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add, // Ícone de adição
                      color: Colors.white, // Cor do ícone
                    ),
                    SizedBox(width: 8.0), // Espaçamento entre o ícone e o texto
                    Text(
                      'Insert', // Texto do botão
                      style: TextStyle(
                        fontSize: 16.0, // Tamanho do texto
                        fontWeight: FontWeight.bold, // Negrito
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insertButtonPress(BuildContext context) async {
    final String nomeLivro = nomeLivroController.text;
    final String nomeAutor = nomeAutorController.text;
    final double preco = double.parse(precoController.text);

    try {
      if (nomeLivro.isEmpty || nomeAutor.isEmpty || preco <= 0) {
        _showDialog(context, 'Erro',
            'Por Favor, preencha todos os campos corretamente.', Colors.red);
      } else {
        Database db = await Connection.get();

        await db.insert(
          'livros',
          {
            'nomeLivro': nomeLivro,
            'nomeAutor': nomeAutor,
            'preco': preco,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        _showDialog(
            context, 'Sucesso', 'Livro inserido com Sucesso', Colors.blue);
      }
    } catch (e) {
      _showDialog(context, 'Erro', 'Erro ao inserir o livro: $e', Colors.red);
    }
  }

  void _showDialog(
      BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: color)),
              onPressed: () {
                Navigator.of(context).pop();
                nomeLivroController.clear();
                nomeAutorController.clear();
                precoController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
