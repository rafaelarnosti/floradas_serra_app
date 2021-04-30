import 'dart:ui';
import 'package:floradas_serra_app/screens/receita.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:floradas_serra_app/model/receita.dart';
import 'dart:async'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? userCredential;

class ConsultaReceita extends StatefulWidget {
  ConsultaReceita(
      {required this.receita, required this.docId, required this.url});
  final Receita receita;
  final String docId;
  final String url;
  @override
  _ConsultaReceitaState createState() =>
      _ConsultaReceitaState(receita: receita, docId: docId, url: url);
}

class _ConsultaReceitaState extends State<ConsultaReceita> {
  _ConsultaReceitaState(
      {required this.receita, required this.docId, required this.url});
  final Receita receita;
  final String docId;
  final String url;

  @override
  void initState() {
    super.initState();
    userCredential = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sitio Floradas da Serra"),
              actions: <Widget>[
                if (userCredential!.email == 'rlm.arnosti@gmail.com' &&
                    receita.ativacao == 'nao') ...[
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        updateReceita(docId);
                        _showDialog(context, 'Receita Aprovada',
                            'Sua receita foi aprovada');
                      },
                      child: Icon(Icons.verified),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      navigateToReceita(
                          Receita(
                              titulo: receita.titulo,
                              ingredientes: receita.ingredientes,
                              receita: receita.receita,
                              ativacao: receita.ativacao),
                          docId,
                          context,
                          url);
                    },
                    child: Icon(Icons.edit),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Apagar Receita'),
                              content: Text(
                                  'Você tem Certeza que deseja apagar a Receita?'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, "/home");
                                      deleteReceita(docId);
                                    },
                                    child: Text('Sim')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Não'))
                              ],
                            );
                          });
                    },
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
            body: Container(
                alignment: Alignment.center,
                color: Colors.white,
                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/floradasserra.png',
                      image: url,
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      child: Text(receita.titulo,
                          style: TextStyle(
                            fontSize: 25.0,
                            decoration: TextDecoration.none,
                          )),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: Text('Ingredientes',
                          style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic)),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: Text(receita.ingredientes,
                          style: TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.none,
                          )),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: Text('Modo de Preparo',
                          style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic)),
                    ),
                  ]),
                  Row(children: [
                    Expanded(
                      child: AutoSizeText(receita.receita,
                          style: TextStyle(
                            fontSize: 20.0,
                            decoration: TextDecoration.none,
                          )),
                    ),
                  ]),
                ])))));
  }

  void navigateToReceita(
      Receita receita, String IdDoc, BuildContext context, String url) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Receitas(
                  receita: receita,
                  IdDoc: IdDoc,
                  url: url,
                )));
  }

  CollectionReference receitas =
      FirebaseFirestore.instance.collection('receitas');

  Future<void> deleteReceita(String IdDoc) {
    return receitas.doc(IdDoc).delete();
  }

  Future<void> updateReceita(String idDoc) {
    return receitas.doc(idDoc).update({'ativacao': 'sim'});
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
                  Navigator.pushNamed(context, '/home');
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

  String tratarUrl(String url) {
    if (url == "") {
      url = "images/floradasserra.png";
    }
    return url;
  }
}
