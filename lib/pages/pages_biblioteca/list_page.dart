import 'package:biblioteca_flutter/data/biblioteca_data.dart';
import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<BibliotecaModel> livros = [];
  List<String> generos = [];
  String? _generoSelecionado;

  Future<void> _loadLivros() async {
    final books = await BibliotecaDatabase.instance.getLivros();
    setState(() {
      livros = books;
    });
  }

  Future<void> _buscarGeneros() async {
    final listGeneros = await BibliotecaDatabase.instance.getBuscarGeneros();
    setState(() {
      generos = ["Todos", ...listGeneros];
    });
  }

  Future<void> _filtrarLivrosGenero() async {
    if (_generoSelecionado == null || _generoSelecionado == "Todos") {
      _loadLivros();
    } else {
      final books = await BibliotecaDatabase.instance.getLivrosByGenero(_generoSelecionado!);
      setState(() {
        livros = books;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLivros();
    _buscarGeneros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'List Book',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _generoSelecionado,
              onChanged: (String? newValue) {
                setState(() {
                  _generoSelecionado = newValue;
                  _filtrarLivrosGenero();
                });
              },
              items: generos.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    gradient: LinearGradient(
                      colors: index % 2 == 0
                          ? [Colors.green.shade200, Colors.grey.shade600]
                          : [Colors.grey.shade200, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: livro.image != null
                        ? CircleAvatar(
                      backgroundImage: FileImage(File(livro.image!)),
                      radius: 30,
                    )
                        : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.book, color: Colors.white),
                    ),
                    title: Text(livro.nomeLivro),
                    subtitle: Text(
                      'Autor: ${livro.nomeAutor}\nPreço: R\$${livro.preco}\nGênero: ${livro.genero}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
