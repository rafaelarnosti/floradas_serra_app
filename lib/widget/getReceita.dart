import 'package:floradas_serra_app/widget/receitacard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:floradas_serra_app/model/receita.dart';

class GetReceita extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GetReceitaState();
}

class GetReceitaState extends State<GetReceita> {
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List<QueryDocumentSnapshot> _allResults = [];
  List<QueryDocumentSnapshot> _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getReceitas();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    List<QueryDocumentSnapshot> showResults = [];

    if (_searchController.text != "") {
      for (var receitaSnapshot in _allResults) {
        var title = Receita.fromSnapshot(receitaSnapshot).titulo.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(receitaSnapshot);
        }
      }
    } else {
      showResults = _allResults;
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getReceitas() async {
    var data = await FirebaseFirestore.instance
        .collection('receitas')
        .where('ativacao', isNotEqualTo: 'nao')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
              flex: 3,
              child: ListView.builder(
                  itemCount: _resultsList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) =>
                      buildReceitaCard(context, _resultsList[index])))
        ],
      ),
    );
  }
}
