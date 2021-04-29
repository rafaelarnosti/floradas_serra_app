import 'package:floradas_serra_app/screens/authentication.dart';
import 'package:floradas_serra_app/util/dbhelper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart'; // new

import 'package:floradas_serra_app/screens/home.dart';
import 'dart:async'; // new
import 'package:firebase_core/firebase_core.dart'; // new

ApplicationState applicationState = new ApplicationState();

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => FloradasSerraApp(),
    child: Home(),
  ));
}

class FloradasSerraApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Sitio Floradas Da Serra',
              theme: ThemeData(primarySwatch: Colors.yellow),
              routes: {'/home': (context) => Home()},
              home: Login());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.white,
        );
      },
    );
  }
}
