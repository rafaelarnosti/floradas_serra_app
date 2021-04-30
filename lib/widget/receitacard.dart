import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floradas_serra_app/model/receita.dart';
import 'package:floradas_serra_app/screens/consultareceita.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? userCredential;

Widget buildReceitaCard(BuildContext context, DocumentSnapshot document) {
  final receita = Receita.fromSnapshot(document);

  userCredential = FirebaseAuth.instance.currentUser;

  return new Container(
    child: Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        receita.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      )),
                  if (userCredential!.email == 'rlm.arnosti@gmail.com' &&
                      receita.ativacao == 'nao') ...[
                    Icon(Icons.verified),
                  ],
                  Spacer(),
                ]),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConsultaReceita(
                        receita: receita,
                        docId: document.id,
                        url: document['url'],
                      )));
        },
      ),
    ),
  );
}
