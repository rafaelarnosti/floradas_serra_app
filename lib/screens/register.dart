import 'package:firebase_auth/firebase_auth.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:floradas_serra_app/screens/authentication.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Criar Conta'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Coloque seu e-mail',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Coloque seu email para continuar';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: _displayNameController,
                            decoration: const InputDecoration(
                              hintText: 'Nome Completo',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Coloque seu nome';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Senha',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Coloque sua senha';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              SizedBox(width: 16),
                              StyledButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    registrarConta(
                                        context,
                                        _emailController.text,
                                        _displayNameController.text,
                                        _passwordController.text,
                                        (e) => {
                                              _showErrorDialog(context,
                                                  'Failed to create account', e)
                                            });
                                  }
                                },
                                child: Text('Salvar'),
                              ),
                              SizedBox(width: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

void registrarConta(
    BuildContext context,
    String email,
    String displayName,
    String password,
    void Function(FirebaseAuthException e) errorCallback) async {
  try {
    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    await credential.user!.updateProfile(displayName: displayName);

    if (!credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
    }

    _showDialog(
        context,
        'Usuario Cadastrado com Sucesso',
        'Usuario ' +
            displayName +
            ' cadastrado com Sucesso. Para acessar o aplicativo verifique seu e-mail e realize o processo de verificação!!!');
  } on FirebaseAuthException catch (e) {
    errorCallback(e);
  }
}

void _showDialog(BuildContext context, String title, String e) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
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
                navigateToAuthentication(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      });
}

void navigateToAuthentication(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Login()));
}

void _showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
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
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      });
}
