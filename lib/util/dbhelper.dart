import 'dart:async'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:floradas_serra_app/model/receita.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
  }

  Future<DocumentReference> addReceita(
      BuildContext context, Receita receita, String url) {
    _showDialog(context, 'Receita em Aprovação',
        'Sua receita esta em aprovação, assim que ela for aprovada ela irá aparecer na tela de receitas');
    return FirebaseFirestore.instance.collection('receitas').add({
      'receita': receita.receita,
      'ingredientes': receita.ingredientes,
      'titulo': receita.titulo,
      'url': url,
      'ativacao': receita.ativacao
    });
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
                  Navigator.pushReplacementNamed(context, '/home');
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

  Future<void> updateReceita(
      BuildContext context, Receita receita, String IdDoc, String url) {
    _showDialog(context, 'Receita em Aprovação',
        'Sua receita esta em aprovação, assim que ela for aprovada ela irá aparecer na tela de receitas');
    return FirebaseFirestore.instance.collection('receitas').doc(IdDoc).update({
      'receita': receita.receita,
      'titulo': receita.titulo,
      'ingredientes': receita.ingredientes,
      'url': url,
      'ativacao': receita.ativacao
    });
  }
}
