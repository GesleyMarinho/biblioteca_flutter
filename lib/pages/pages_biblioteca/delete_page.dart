import 'package:biblioteca_flutter/data/biblioteca_data.dart';
import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  List<BibliotecaModel> livros = [];

  Future<void> _loadLivros() async {
    final books = await BibliotecaDatabase.instance.getLivros();
    setState(() {
      livros = books;
    });

    print(livros);
  }

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delete Book',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: livros.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                gradient: LinearGradient(
                  colors: index % 2 == 0
                      ? [Colors.grey.shade500, Colors.grey.shade400]
                      : [Colors.red.shade100, Colors.red.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(), // estilo da motion
                  extentRatio: 0.4, // limita o tamanho da caixa do "deletar"
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(6.0),
                      onPressed: (BuildContext context) {
                        _confirmDelete(context, livros[index].id!);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Excluir',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(livros[index].nomeLivro),
                  subtitle: Text(
                      'Autor: ${livros[index].nomeAutor}\nPreço: R\$${livros[index].preco}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final bool? shoulDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(' delete book'),
          content: const Text('Você deseja relamente excluir o livro ?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
    if (shoulDelete == true) {
      _deleteLivro(id);
      print(id);
    }
  }

  Future<void> _deleteLivro(int id) async {
    await BibliotecaDatabase.instance
        .deleteLivro(id); //verificando no banco de dados;
    _loadLivros(); // Recarregar a lista após a exclusão
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Livro deletado com sucesso!'),
        duration: Duration(seconds: 5),
      ),
    );
  }
}
