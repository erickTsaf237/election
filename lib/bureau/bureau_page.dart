

import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/composant/MonDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../backend/bureau_dto.dart';
import '../main.dart';
import '../section/section_page.dart';
import 'bureau.dart';

class BureauPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyBureauPage();
  }
}

class MyBureauPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyBureauPage();
  }
}

class _MyBureauPage extends State<MyBureauPage> {
  void _incrementCounter() {
    Bureau.etat = this;
    setState(() {});
    showDialog(context: context, builder: (context){
      return CreateBureau();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // getOrg();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Bureau'),
        actions: const [
          // MonDrawer()
        ],
      ),
      // drawer: MyHomePage.who=='admin'?null: const MonDrawer(),
      body: Container(
        alignment: Alignment.center,
        child:  FutureBuilder(
            future: BureauDTO.getAll(),
            builder: (context, AsyncSnapshot<http.Response> response) {
              print(BackendConfig.curenSection!.id);
              if (response.hasError) {
                return const Text('Il y\'a eu une erreur');
              } else if (response.hasData) {
                String? a = response.data?.body;
                String b = a!;
                dynamic r = jsonDecode(b);
                int taille = r.length;
                if(taille == 0) {
                  return const Text('Cette section ne contient pas de bureau de vote');
                }
                // Employe.liste = [];
                return ListView(children: [
                  for (int i = 0; i < taille; i++)
                    Bureau(BureauDTO.http(r[i])),
                ]);
              }
              return Text('Liste vide');
            }),
      ),
      floatingActionButton: getFlotting(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getFlotting() {
    if (MyHomePage.who == 'employe') {
      return FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
        },
        tooltip: 'Nouveau bureau',
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    Bureau.etat = this;
    // BackendConfig.etat = this;
    // Employe.etat = this;
  }

}