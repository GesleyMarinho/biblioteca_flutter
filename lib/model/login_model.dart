class LoginModel {
  final int? id;
  final String? nome;
  final String email;
  final String senha;
  final String? confirmaSenha;

  LoginModel({
    this.id,
    this.nome,
    required this.email,
    required this.senha,
    this.confirmaSenha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'confirmaSenha': confirmaSenha,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      senha: json['senha'] as String,
      confirmaSenha: json['confirmaSenha'] as String,
    );
  }
}
