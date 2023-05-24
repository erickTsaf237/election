import 'dart:convert';

import 'package:election/backend/employe.dart';
import 'package:election/composant/MonDrawer.dart';
import 'package:election/composant/accueille.dart';
import 'package:election/conexion/choix.dart';
import 'package:election/conexion/login.dart';
import 'package:election/conexion/logup.dart';
import 'package:election/election/createElection.dart';
import 'package:election/organisation.dart/create.dart';
import 'package:election/section/section_page.dart';
import 'package:flutter/material.dart';

import 'backend/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/choice',
      routes: {
        '/choice': (context) => Choice(),
        '/login': (context) => Login(),
        '/logup': (context) => const Logup(),
        '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/section': (context) => MyHomePage.who=='admin'?SectionPage():SectionePage(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static late UserBackend currentUser;
  static late EmployeDTO currentEMploye;
  static late String who;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    print(MyHomePage.currentUser.organisation);
    showDialog(
        context: context,
        builder: (context) {
          return MyHomePage.currentUser.organisation == null
              ? CreateOrganisation()
              : CreateElection();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MonDrawer(),
      body: Accueille(),
      backgroundColor: null,
      floatingActionButton: getFlotting(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getFlotting() {
    if (MyHomePage.who == 'admin') {
      return FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
        },
        tooltip: 'Nouvelle election',
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
}
