class BibliotecaModel {
  final int id;
  final String nomeLivro;
  final String nomeAutor;
  final double preco;
  final String? image;
  final String genero;
   bool isFavorite  ;

  BibliotecaModel({
    required this.id,
    required this.nomeLivro,
    required this.nomeAutor,
    required this.preco,
    this.image,
    required this.genero,
    this.isFavorite = false ,
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
    };
  }
}
