class BibliotecaModel {
  final int id;
  final String nomeLivro;
  final String nomeAutor;
  final double preco;
  final String? image;
  final String genero;

  bool isFavorite;
  final double rating;
  final DateTime? data;
  final String? comentario;

  BibliotecaModel({
    required this.id,
    required this.nomeLivro,
    required this.nomeAutor,
    required this.preco,
    this.image,
    required this.genero,
    this.isFavorite = false,
    this.rating = 0.0,
    this.data,
    this.comentario,
  });

  factory BibliotecaModel.fromJson(Map<String, dynamic> json) {
    return BibliotecaModel(
      id: json['id'],
      nomeLivro: json['nomeLivro'],
      nomeAutor: json['nomeAutor'],
      preco: json['preco'],
      genero: json['genero'],
      image: json['image'],
      isFavorite: json['isFavorite'] == 1,
      rating: json['rating']?.toDouble() ?? 0.0,
      data: json['data'] != null ? DateTime.parse(json['data']) : null,
      comentario: json['comentario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeLivro': nomeLivro,
      'nomeAutor': nomeAutor,
      'preco': preco,
      'genero': genero,
      'image': image,
      'isFavorite': isFavorite ? 1 : 0,
      'rating': rating,
      'data': data?.toIso8601String(),
      'comentario': comentario,
    };
  }
}
