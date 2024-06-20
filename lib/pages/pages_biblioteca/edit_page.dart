import 'package:biblioteca_flutter/data/biblioteca_data.dart';
import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:flutter/material.dart';


class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
          'Edição dos Livros ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: livros.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                colors: index % 2 == 0
                    ? [Colors.grey.shade200, Colors.grey.shade600]
                    : [Colors.orange.shade200, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              title: Text(livros[index].nomeLivro),
              subtitle: Text(
                  'Autor: ${livros[index].nomeAutor}\nPreço: R\$${livros[index].preco}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editLivro(livros[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _editLivro(BibliotecaModel livro) {
    final TextEditingController nomeLivroController =
        TextEditingController(text: livro.nomeLivro);
    final TextEditingController nomeAutorController =
        TextEditingController(text: livro.nomeAutor);
    final TextEditingController precoController =
        TextEditingController(text: livro.preco.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeLivroController,
                  decoration: const InputDecoration(labelText: 'Nome do Livro'),
                ),
                TextField(
                  controller: nomeAutorController,
                  decoration: const InputDecoration(labelText: 'Autor'),
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String nomeLivro = nomeLivroController.text;
                final String nomeAutor = nomeAutorController.text;
                final double preco = double.parse(precoController.text);

                print('Nome Livro: $nomeLivro');
                print('Nome Autor: $nomeAutor');
                print('Preço: $preco');

                if (nomeLivro.isNotEmpty && nomeAutor.isNotEmpty && preco > 0) {
                  final updateLivro = BibliotecaModel(
                    id: livro.id,
                    nomeLivro: nomeLivro,
                    nomeAutor: nomeAutor,
                    preco: preco,
                  );
                  await BibliotecaDatabase.instance.updateLivro(updateLivro);
                  _loadLivros();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos corretamente'),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
