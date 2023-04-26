import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/composant/MonDrawer.dart';
import 'package:election/composant/accueille.dart';
import 'package:election/conexion/login.dart';
import 'package:election/conexion/logup.dart';
import 'package:election/election/createElection.dart';
import 'package:election/organisation.dart/create.dart';
import 'package:flutter/material.dart';

import 'backend/organisation.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login':(context)=> Login(),
        '/logup': (context)=> Logup(),
        '/home': (context)=>const MyHomePage(title: 'Flutter Demo Home Page'),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static late UserBackend currentUser;

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
    showDialog(context: context, builder: (context){
      return MyHomePage.currentUser.organisation==null?CreateOrganisation():CreateElection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const MonDrawer(),
      body:  Accueille(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter();

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
