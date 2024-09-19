import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import '../../data/biblioteca_data.dart';
import '../../data/detalhesLivros_data.dart';
import '../../model/biblioteca_model.dart';

class DetalheLivrosPage extends StatefulWidget {
  const DetalheLivrosPage({super.key});

  @override
  State<DetalheLivrosPage> createState() => _DetalheLivrosPageState();
}

class _DetalheLivrosPageState extends State<DetalheLivrosPage> {
  List<BibliotecaModel> livros = [];
  List<String> generos = [];


  @override
  void initState() {
    super.initState();

    _loadLivros();
  }

  Future<void> _loadLivros() async {
    final livro = await BibliotecaDatabase.instance.getLivros();
    setState(() {
      livros = livro;
    });
  }



  Future<void> _atualizarRating(int bookId, double rating) async {
    await DetalheslivrosData.instance.updateRating(bookId, rating);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Avaliação atualizada com sucesso!')),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: ListView.builder(
            itemCount: livros.length,
            itemBuilder: (context, index) {
              final livro = livros[index];

              return Card(
                child: Container(
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
                    title: Text(
                      livro.nomeLivro,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Autor: ${livro.nomeAutor}\nPreço: R\$${livro.preco}\nGênero: ${livro.genero}',
                        ),
                        const SizedBox(height: 8.0),
                        RatingBar.builder(
                          initialRating: livro.rating ?? 0.0,
                          minRating: 1,
                          itemSize: 30,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            _atualizarRating(livro.id, rating);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
