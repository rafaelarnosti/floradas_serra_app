import 'package:flutter/material.dart';
import 'package:floradas_serra_app/model/receita.dart';
import 'package:floradas_serra_app/src/widgets.dart';
import 'package:floradas_serra_app/util/dbhelper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core; // new

ApplicationState applicationState = new ApplicationState();

class Receitas extends StatefulWidget {
  Receitas({required this.receita, required this.IdDoc, required this.url});
  final Receita receita;
  final String IdDoc;
  final String url;

  @override
  State<StatefulWidget> createState() => ReceitasState(receita, IdDoc, url);
}

class ReceitasState extends State<Receitas> {
  Receita receita;
  String IdDoc;
  ReceitasState(this.receita, this.IdDoc, this._url);
  final _formKey = GlobalKey<FormState>(debugLabel: '_ReceitasState');
  final _controller = TextEditingController();
  final _controllerIngredientes = TextEditingController();
  final _controllerReceita = TextEditingController();
  late PickedFile _imageFile;
  late String _url;

  @override
  Widget build(BuildContext context) {
    _controller.text = receita.titulo;
    _controllerIngredientes.text = receita.ingredientes;
    _controllerReceita.text = receita.receita;

    return Scaffold(
        appBar:
            AppBar(title: Text("Sitio Floradas da Serra"), actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                openCamera(context);
              },
              child: Icon(Icons.camera_alt),
            ),
          ),
        ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: 'Coloque o Titulo da sua Receita',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por Favor Coloque um Titulo para continuar';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _controllerIngredientes,
                      keyboardType: TextInputType.multiline,
                      maxLines: 99,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          hintText: 'Coloque os ingredientes da sua Receita'),
                    )),
                Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _controllerReceita,
                      keyboardType: TextInputType.multiline,
                      textAlign: TextAlign.start,
                      maxLines: 99,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          hintText: 'Coloque o modo de preparar sua Receita'),
                    )),
                SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      initializeVariables(_url);
                      addOrUpdatereceitas(
                          context,
                          _controller.text,
                          _controllerIngredientes.text,
                          _controllerReceita.text,
                          IdDoc,
                          _url);
                      _controller.clear();
                      _controllerIngredientes.clear();
                      _controllerReceita.clear();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text(
                        'Enviar',
                        style: TextStyle(
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  final picker = ImagePicker();

  void openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    _imageFile = PickedFile(pickedFile!.path);
    _onLoading(context);
    uploadFile(_imageFile.path);
  }

  void initializeVariables(String url) {
    _url = "";
    if (url != "") {
      _url = url;
    }
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    String url = '';

    try {
      firebase_storage.UploadTask uploadTask = firebase_storage
          .FirebaseStorage.instance
          .ref('uploads/$filePath')
          .putFile(file);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      await taskSnapshot.ref.getDownloadURL().then((value) => {url = value});

      _url = url;
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }
}

void _onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Aguarde, enquanto inserimos a sua imagem!!!!"),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 10), () {
    Navigator.pop(context); //pop dialog
  });
}

Future<void> addOrUpdatereceitas(BuildContext context, String titulo,
    String ingredientes, String receita, String IdDoc, String url) async {
  if (IdDoc == "") {
    await applicationState.addReceita(
        context,
        Receita(
            titulo: titulo,
            ingredientes: ingredientes,
            receita: receita,
            ativacao: 'nao'),
        url);
  } else {
    await applicationState.updateReceita(
        context,
        Receita(
            titulo: titulo,
            ingredientes: ingredientes,
            receita: receita,
            ativacao: 'nao'),
        IdDoc,
        url);
  }
}
