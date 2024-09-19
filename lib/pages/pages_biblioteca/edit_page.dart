import 'dart:io';
import 'package:biblioteca_flutter/data/biblioteca_data.dart';
import 'package:biblioteca_flutter/model/biblioteca_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<BibliotecaModel> livros = [];
  final ImagePicker _picker = ImagePicker();
  File? _image;

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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
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
        title: const Text(
          'Edição de Livros ',
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
                  'Autor: ${livros[index].nomeAutor}\nPreço: R\$${livros[index].preco}\nGênero ${livros[index].genero}\nComentârio:${livros[index].comentario}'),
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
    final TextEditingController generoController =
        TextEditingController(text: livro.genero);
    final TextEditingController comentarioController =
        TextEditingController(text: livro.comentario);

    _image = livro.image != null ? File(livro.image!) : null;

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
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: generoController,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: comentarioController,
                  decoration: const InputDecoration(labelText: 'Comentário'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
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
                final String genero = generoController.text;
                String? imagePath = livro.image;
                final String comentario = comentarioController.text;

                if (_image != null && _image!.path != livro.image) {
                  final Directory appDir =
                      await getApplicationDocumentsDirectory();
                  imagePath = path.join(
                      appDir.path, 'images', path.basename(_image!.path));
                  await Directory(path.dirname(imagePath!))
                      .create(recursive: true);
                  await _image!.copy(imagePath);
                }

                if (nomeLivro.isNotEmpty ||
                    nomeAutor.isNotEmpty ||
                    preco > 0 ||
                    genero.isNotEmpty ||
                    comentario.isNotEmpty) {
                  final updateLivro = BibliotecaModel(
                    id: livro.id,
                    nomeLivro: nomeLivro,
                    nomeAutor: nomeAutor,
                    preco: preco,
                    image: imagePath,
                    genero: genero,
                    comentario: comentario,
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
