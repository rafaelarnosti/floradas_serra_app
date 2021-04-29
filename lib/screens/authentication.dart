import 'package:firebase_auth/firebase_auth.dart';
import 'package:floradas_serra_app/screens/home.dart';
import 'package:floradas_serra_app/screens/register.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:flutter/material.dart';

import 'forgotPassword.dart';

FirebaseAuth auth = FirebaseAuth.instance;
enum ApplicationLoginState {
  register,
  password,
  verifiedEmail,
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('images/floradasserra.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                  controller: _controllerUser,
                  decoration: InputDecoration(hintText: 'Usuario'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Usuario Obrigatorio';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                  controller: _controllerPassword,
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Senha Obrigatoria';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StyledButton(
                  child: Text(
                    'LogIn',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    loginSitio(
                        context,
                        _controllerUser.text,
                        _controllerPassword.text,
                        (e, applicationState) => _showErrorDialog(context,
                            'Não foi possivel logar!', e, applicationState));

                    _controllerUser.clear();
                    _controllerPassword.clear();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Se você não tem cadastro, clique em LogIn',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

void loginSitio(
    BuildContext context,
    String email,
    String password,
    void Function(String e, ApplicationLoginState applicationState)
        error) async {
  try {
    if (password.trim() == "") {
      password = "teste";
    }
    if (email.trim() == "") {
      email = "teste@teste.com";
    }
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());

    if (userCredential.user!.emailVerified) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      _showErrorDialog(
          context,
          'E-mail não verificado',
          'Verifique o seu email para acessar o app',
          ApplicationLoginState.verifiedEmail);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      error('Vamos Cadastrar seu usuario?', ApplicationLoginState.register);
    } else if (e.code == 'wrong-password') {
      error('Senha Incorreta', ApplicationLoginState.password);
    }
  }
}

void _showErrorDialog(BuildContext context, String title, String e,
    ApplicationLoginState applicationState) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        switch (applicationState) {
          case ApplicationLoginState.password:
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 24),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      e,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                StyledButton(
                  onPressed: () {
                    navigateToPassword(context);
                  },
                  child: Text(
                    'Esqueci minha Senha',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                StyledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          case ApplicationLoginState.register:
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 24),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      e,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                StyledButton(
                  onPressed: () {
                    navigateToRegister(context);
                  },
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                StyledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          case ApplicationLoginState.verifiedEmail:
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 24),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      e,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                StyledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            );
          default:
            return Row(
              children: [
                Text("Internal error, this shouldn't happen..."),
              ],
            );
        }
      });
}

void navigateToRegister(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Register()));
}

void navigateToPassword(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => ForgotPassword()));
}
