import 'package:cloud_firestore/cloud_firestore.dart';

class Receita {
  String titulo;
  String ingredientes;
  String receita;
  String ativacao;

  Receita(
      {required this.titulo,
      required this.ingredientes,
      required this.receita,
      required this.ativacao});

  Receita.fromSnapshot(DocumentSnapshot snapshot)
      : titulo = snapshot['titulo'],
        ingredientes = snapshot['ingredientes'],
        receita = snapshot['receita'],
        ativacao = snapshot['ativacao'];
}
