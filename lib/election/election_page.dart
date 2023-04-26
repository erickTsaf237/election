

import 'dart:convert';

import 'package:election/backend/candidat.dart';
import 'package:election/backend/config.dart';
import 'package:election/candidat/create_candidat.dart';
import 'package:flutter/material.dart';

import '../backend/election.dart';
import '../candidat/candidat.dart';
import '../election/election.dart';
import '../main.dart';
import 'package:http/http.dart' as http;


class ElectionPage extends StatelessWidget {

  late ElectionDTO election;

  ElectionPage(this.election,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyElectionPage(election);
  }
}

class MyElectionPage extends StatefulWidget {
  late ElectionDTO election;

  MyElectionPage(this.election);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyElectionPage(election);
  }
}

class _MyElectionPage extends State<MyElectionPage> {
  late ElectionDTO election;

  void _incrementCounter() {
    setState(() {
    });
    BackendConfig.etat = this;
    showDialog(context: context, builder: (context){
      return CreateCandidat();
    });
  }

  _MyElectionPage(this.election){
    BackendConfig.curenElectifon = election;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(election.libele),),
      body: Container(
        alignment: Alignment.center,
        child:  FutureBuilder(
            future: CandidatDTO.getAll(),
            builder: (context, AsyncSnapshot<http.Response> response) {
              // print(response);
              if (response.hasError)
                return Text('Il y\'a eu une erreur');
              else if (response.hasData) {
                String? a = response.data?.body;
                String b = a!;
                dynamic r = jsonDecode(b);
                int taille = r.length;
                return ListView(children: [
                  for(int i = 0; i < taille; i++)
                    Candidat(CandidatDTO.toCandidat(r[i])),
                ]);
              }
              return const Text('Liste vide');
            }),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _incrementCounter();
          },
          tooltip: 'nouveau candidat',
          child: const Icon(Icons.add),

        )
    );
  }

  @override
  void initState() {
    super.initState();
    BackendConfig.etat = this;
  }
}


