import 'package:floradas_serra_app/model/receita.dart';
import 'package:floradas_serra_app/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:floradas_serra_app/screens/receita.dart';
import 'package:floradas_serra_app/widget/getReceita.dart';

ApplicationState applicationState = ApplicationState();

final String choice = 'Ativar Receitas';

const mnuAtivar = 'Ativar Receitas';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sitio Floradas da Serra"),
      ),
      body: GetReceita(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          navigateToReceita(
              Receita(titulo: '', ingredientes: '', receita: '', ativacao: ''),
              '',
              '');
        },
      ),
    ));
  }

  void navigateToReceita(Receita receita, String IdDoc, String url) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Receitas(
                  receita: receita,
                  IdDoc: IdDoc,
                  url: url,
                )));
  }
}
