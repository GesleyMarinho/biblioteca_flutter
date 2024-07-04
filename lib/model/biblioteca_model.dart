class BibliotecaModel {
  final int? id;
  final String nomeLivro;
  final String nomeAutor;
  final double preco;
  final String? image;

  BibliotecaModel({
    required this.id,
    required this.nomeLivro,
    required this.nomeAutor,
    required this.preco,
    this.image
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeLivro': nomeLivro,
      'nomeAutor': nomeAutor,
      'preco': preco,
      'image': image,
    };
  }

  factory BibliotecaModel.fromJson(Map<String, dynamic> json) {
    return BibliotecaModel(
      id: json['id'] as int,
      nomeLivro: json['nomeLivro'] as String,
      nomeAutor: json['nomeAutor'] as String,
      preco: json['preco'] as double,
      image: json['image'] as String,
     );
  }
}
