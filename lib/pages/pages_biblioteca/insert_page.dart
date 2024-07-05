import 'dart:io';
import 'package:biblioteca_flutter/conexao_BD/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController nomeAutorController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(
      source: source, // Pode ser ImageSource.camera para a câmera
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
          child: SingleChildScrollView(
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
                TextField(
                  controller: generoController,
                  decoration:  InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:const  BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelText: 'Gênero',
                    hintText: 'Ficção ciêntifica...',
                    labelStyle:const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: const Icon(
                      Icons.book_sharp,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: _image == null
                        ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.blue,
                            size: 50,
                          )
                        : Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _insertButtonPress(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    // Cor de fundo do botão
                    padding: const EdgeInsets.all(16.0),
                    // Preenchimento interno
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
                      SizedBox(width: 8.0),
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
      ),
    );
  }

  void _insertButtonPress(BuildContext context) async {
    final String nomeLivro = nomeLivroController.text;
    final String nomeAutor = nomeAutorController.text;
    final double preco = double.parse(precoController.text);
    final String genero = generoController.text;

    if (nomeLivro.isEmpty || nomeAutor.isEmpty || preco <= 0 || genero.isEmpty ) {
      _showDialog(context, 'Erro',
          'Por Favor, preencha todos os campos corretamente.', Colors.red);
    } else {
      try {
        String? imagePath;
        if (_image != null) {
          final Directory appDir = await getApplicationDocumentsDirectory();
          imagePath =
              path.join(appDir.path, 'images', path.basename(_image!.path));
          await Directory(path.dirname(imagePath)).create(recursive: true);
          await _image!.copy(imagePath);
        }

        Database db = await Connection.get();
        await db.insert(
          'livros',
          {
            'nomeLivro': nomeLivro,
            'nomeAutor': nomeAutor,
            'preco': preco,
            'image': imagePath,
            'genero': genero,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        _showDialog(
            context, 'Sucesso', 'Livro inserido com Sucesso', Colors.blue);
      } catch (e) {
        _showDialog(context, 'Erro', 'Erro ao inserir o livro: $e', Colors.red);
      }
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
                generoController.clear();
                setState(() {
                  _image = null;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
