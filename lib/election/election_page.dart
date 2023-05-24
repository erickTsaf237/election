import 'dart:convert';

import 'package:election/backend/candidat.dart';
import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/candidat/create_candidat.dart';
import 'package:flutter/material.dart';

import '../backend/bureau_dto.dart';
import '../backend/election.dart';
import '../backend/employe.dart';
import '../bureau/bureau.dart';
import '../candidat/candidat.dart';
import '../election/election.dart';
import '../employe/employe.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class ElectionPage extends StatelessWidget {
  late ElectionDTO election;

  ElectionPage(this.election, {Key? key}) : super(key: key);

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
    setState(() {});
    BackendConfig.etat = this;
    showDialog(
        context: context,
        builder: (context) {
          return MyHomePage.who == 'admin' ? CreateCandidat() : CreateBureau();
        });
  }

  _MyElectionPage(this.election) {
    BackendConfig.curenElectifon = election;
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: getFlotting(),
        body: TabBarView(
          children: [
            getCandidatListe(context),
            getBureauListe(context)
          ],
        ),
        appBar: AppBar(

          title: Text(BackendConfig.curenElectifon!.libele),
          bottom:  const TabBar(
            tabs: [
              Text('candidat', style: TextStyle(fontSize: 23)),
              Text('section', style: TextStyle(fontSize: 23)),
            ],
          ),
        ),
      ),
    );
  }

  getFlotting() {
    if (MyHomePage.who == 'admin') {
      return FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
        },
        tooltip: 'nouveau candidat',
        child: const Icon(Icons.add),
      );
    } else if (MyHomePage.who == 'employe') {
      if (BackendConfig.curenSection!.id_responsable != null) {
        if (MyHomePage.currentEMploye.id! ==
            BackendConfig.curenSection!.id_responsable) {
          return FloatingActionButton(
            onPressed: () async {
              _incrementCounter();
            },
            tooltip: 'nouveau Bureau',
            child: const Icon(Icons.add),
          );
        }
      }
    }
    return null;
  }

  getCandidatListe(BuildContext context){
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: CandidatDTO.getAll(),
          builder: (context, AsyncSnapshot<http.Response> response) {
            // print(response);
            if (response.hasError) {
              return Text('Il y\'a eu une erreur');
            } else if (response.hasData) {
              String? a = response.data?.body;
              String b = a!;
              dynamic r = jsonDecode(b);
              int taille = r.length;
              return ListView(children: [
                for (int i = 0; i < taille; i++)
                  Candidat(CandidatDTO.toCandidat(r[i])),
              ]);
            }
            return const Text('Liste vide');
          }),
    );
  }

  getBureauListe(BuildContext context){
    return Container(
        alignment: Alignment.center,



        child: FutureBuilder(
        future: BureauDTO.getAllByIdElection(BackendConfig.curenElectifon!.id!),
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
        }));
  }

  @override
  void initState() {
    super.initState();
    BackendConfig.etat = this;
  }
}
