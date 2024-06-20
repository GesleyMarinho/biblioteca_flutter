import 'package:biblioteca_flutter/data/login_data.dart';
import 'package:biblioteca_flutter/model/login_model.dart';
import 'package:biblioteca_flutter/pages/pages_biblioteca/biblioteca_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_flutter/pages/pages_login/criar_conta_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController senhaLoginController = TextEditingController();

  bool visualizarSenha = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Biblioteca'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(28.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.pinkAccent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Digite os dados de acesso abaixo !!!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32.0),
              CupertinoTextField(
                controller: emailLoginController,
                cursorColor: Colors.yellow,
                padding: const EdgeInsets.all(16.0),
                placeholder: 'Digite o seu Email',
                //obscureText: true,
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14.0),
                style: const TextStyle(color: Colors.white, fontSize: 14.0),
                keyboardType: TextInputType.emailAddress,
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
              ),
              const SizedBox(height: 32.0),
              TextField(
                  controller: senhaLoginController,
                  obscureText: visualizarSenha,
                  //padding: EdgeInsets.all(16.0),
                  cursorColor: Colors.pinkAccent,
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
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
                    hintStyle:
                        const TextStyle(color: Colors.white70, fontSize: 16.0),
                    filled: true,
                    fillColor: Colors.black12,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  )),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 0.8),
                    borderRadius: BorderRadius.circular(7)),
                child: CupertinoButton(
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    // Insira a lógica de criação de conta aqui

                    LoginModel usuario = LoginModel(
                      email: emailLoginController.text,
                      senha: senhaLoginController.text,
                    );

                    //caso o login seja feito com sucesso
                    bool loginSuccess =
                        await LoginData.instace.auteticacaoUsuario(usuario);
                    if (loginSuccess) {
                      emailLoginController.clear();
                      senhaLoginController.clear();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => BibliotecaPage()),
                      );
                    } else {
                      // Exibir mensagem de erro
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Erro'),
                          content: const Text('Email ou senha incorretos.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 0.8),
                    borderRadius: BorderRadius.circular(7)),
                child: CupertinoButton(
                  child: const Text(
                    "Crie sua conta",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CriarContaPage()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
