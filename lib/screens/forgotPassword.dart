import 'package:firebase_auth/firebase_auth.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:floradas_serra_app/screens/authentication.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordForm();
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ForgotPasswordFormState');
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Esqueci minha Senha'),
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
                              hintText: 'Digite seu e-mail',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your email address to continue';
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
                                    alterarSenha(
                                        context,
                                        _emailController.text,
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

void alterarSenha(BuildContext context, String email,
    void Function(FirebaseAuthException e) errorCallback) async {
  try {
    var credential =
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

    _showDialog(context, 'E-mail encaminhado com sucesso',
        'Verifique o e-mail: ' + email + ' para resetar sua senha!!!');
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
