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

  Future<void> _loadLivros() async {
    final books = await BibliotecaDatabase.instance.getLivros();
    setState(() {
      livros = books;
    });
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
        backgroundColor: Colors.green,
        title: const Text(
          'List Book',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
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
              leading: livros[index].image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(livros[index].image!)),
                      radius: 30,
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.book, color: Colors.white),
                    ),
              title: Text(livros[index].nomeLivro),
              subtitle: Text(
                  'Autor: ${livros[index].nomeAutor}\nPreço: R\$${livros[index].preco}'),
            ),
          );
        },
      ),
    );
  }
}
