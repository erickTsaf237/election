import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/composant/MonDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../backend/bureau_dto.dart';
import '../backend/electeur_dto.dart';
import '../electeur/createElecteur.dart';
import '../main.dart';
import 'bureau.dart';

class BureauPage extends StatelessWidget {
  late BureauDTO bureauDTO;

  BureauPage(this.bureauDTO);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyBureauPage(bureauDTO);
  }
}

class MyBureauPage extends StatefulWidget {
  late BureauDTO bureauDTO;

  MyBureauPage(this.bureauDTO);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyBureauPage(bureauDTO);
  }
}

class _MyBureauPage extends State<MyBureauPage> {

  late BureauDTO bureau;

  _MyBureauPage(this.bureau);
  late List<String> pageList = ['Electeur', 'Employe', 'Info'];
  late String page = 'Electeur';


  void _incrementCounter() {
    Bureau.etat = this;
    setState(() {});
    showDialog(
        context: context,
        builder: (context) {
          return CreateBureau();
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // getOrg();
    return Scaffold(
      appBar: AppBar(
        title: Text('Bureau de ${bureau.localisation} (${bureau.ville})'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              for (var ele in pageList)
                PopupMenuItem(
                  child: Text(ele),
                  onTap: () {
                    setState(() {
                      page = ele;
                    });
                  },
                )
            ];
          })
        ],
      ),
      // drawer: MyHomePage.who=='admin'?null: const MonDrawer(),
      body: Container(
        child: buildPage(context),
      ),
      floatingActionButton:
          getFlotting(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildPage(BuildContext context) {
    if (page == 'Electeur') {
      return FutureBuilder(
          future: BureauDTO.getAll(),
          builder: (context, AsyncSnapshot<http.Response> response) {
            return Text('Page electeur vide');
          });
    } else if (page == 'Employe') {
      return FutureBuilder(
          future: BureauDTO.getAll(),
          builder: (context, AsyncSnapshot<http.Response> response) {
            return Text('Page Employe vide');
          });
    } else if (page == 'Info') {
      return FutureBuilder(
          future: BureauDTO.getAll(),
          builder: (context, AsyncSnapshot<http.Response> response) {
            return Text('Page Info vide');
          });
    }
    return Text('data');
  }

  getFlotting() {
    if (MyHomePage.who == 'employe') {
      if (page == pageList[0]) {
      // if (page == pageList[0] && MyHomePage.currentEMploye.id == BackendConfig.curenSection?.id_responsable) {
        return FloatingActionButton(
          onPressed: () async {
            Bureau.etat = this;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyCreateElecteur(ElecteurDTO(bureau.id_section,bureau.id_election, bureau.id!, MyHomePage.currentEMploye.id!))));
          },
          tooltip: 'Importer une Liste d\'electeurs',
          child: const Icon(Icons.add),
        );
      }
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

getListeBureauItem(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder(
        future: BureauDTO.getAll(),
        builder: (context, AsyncSnapshot<http.Response> response) {
          // print(BackendConfig.curenSection!.id);
          if (response.hasError) {
            return const Text('Il y\'a eu une erreur');
          } else if (response.hasData) {
            String? a = response.data?.body;
            String b = a!;
            dynamic r = jsonDecode(b);
            int taille = r.length;
            if (taille == 0) {
              return const Text(
                  'Cette section ne contient pas de bureau de vote');
            }
            // Employe.liste = [];
            return ListView(children: [
              for (int i = 0; i < taille; i++) Bureau(BureauDTO.http(r[i])),
            ]);
          }
          return Text('Liste vide');
        }),
  );
}
