import 'package:biblioteca_flutter/model/login_model.dart';
import 'package:biblioteca_flutter/pages/pages_login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/login_data.dart';

class CriarContaPage extends StatefulWidget {
  CriarContaPage({super.key});

  @override
  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  bool visualizarSenha = true;
  bool visualizarConfirmaSenha = true;

  bool _inseridoComSucesso = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Criar Conta',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8.0, width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Digite seu nome'),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8.0, width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Digite seu email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.password,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8.0, width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: senhaController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Digite a senha ',
                          suffixIcon: IconButton(
                            icon: Icon(
                              visualizarSenha
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                visualizarSenha = !visualizarSenha;
                              });
                            },
                          ),
                        ),
                        obscureText: visualizarSenha,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.password_outlined,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8.0, width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: confirmaSenhaController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Confirme a senha',
                          suffixIcon: IconButton(
                            icon: Icon(
                              visualizarConfirmaSenha
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                visualizarConfirmaSenha =
                                    !visualizarConfirmaSenha;
                              });
                            },
                          ),
                        ),
                        obscureText: visualizarConfirmaSenha,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48.0),
                ElevatedButton(
                  onPressed: () async {
                    // Validando que nenhum campo está vazio
                    if (nomeController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        senhaController.text.isEmpty ||
                        confirmaSenhaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos.'),
                        ),
                      );
                      return;
                    }
                    if (senhaController.text != confirmaSenhaController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('As senhas não coincidem.'),
                        ),
                      );
                      return;
                    }
                    // Criando um objeto para receber os dados e inserir na tabela
                    final novoUsuario = LoginModel(
                      //id: 0,
                      nome: nomeController.text,
                      email: emailController.text,
                      senha: senhaController.text,
                      confirmaSenha: confirmaSenhaController.text,
                    );

                    try {
                      await LoginData.instace.insertUsuario(novoUsuario);
                      print('teste $novoUsuario');
                      print(_inseridoComSucesso);
                      setState(() {
                        _inseridoComSucesso = true;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuário Inserido Com sucesso!'),
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    } catch (e) {
                      setState(() {
                        _inseridoComSucesso = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Algo deu errado.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Criar Conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
