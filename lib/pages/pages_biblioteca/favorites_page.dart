import 'dart:io';

import 'package:biblioteca_flutter/data/favorites_data.dart';
import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<BibliotecaModel> livros = [];

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesData.instance.getFavorites();
    setState(() {
      livros = favorites;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Favoritos'),
        centerTitle: true,
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
                    ? [Colors.yellow.shade200, Colors.yellowAccent.shade400]
                    : [
                        Colors.yellowAccent.shade200,
                        Colors.yellowAccent.shade400
                      ],
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
                  'Autor: ${livros[index].nomeAutor}\nPreço: R\$${livros[index].preco}\nGênero ${livros[index].genero}'),
            ),
          );
        },
      ),
    );
  }
}
