import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/composant/MonDrawer.dart';
import 'package:election/electeur/electeur_button.dart';
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
      body: getTableauElecteur(),
      floatingActionButton:
          getFlotting(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getTableauElecteur() {
    return FutureBuilder(
        future: ElecteurDTO.getElecteurBureau(),
        builder: (context, AsyncSnapshot<http.Response> response) {
          dynamic data = [];
          if (response.hasError) {
            return const Center(
              child: Column(
                children: [
                  Text('Vous n\'etes pas connecte !',
                      style: TextStyle(
                        height: 19,
                      )),
                  Icon(
                    Icons.cloud_off,
                    color: Colors.red,
                    size: 60,
                  )
                ],
              ),
            );
          } else if (response.hasData) {
            String? a = response.data?.body;
            String b = a!;
            data = jsonDecode(b);
            int i = 0;
            int taille = data.length;
            if (taille == 0) {
              return getTableauEleceteur(data);
            }
            return getTableauEleceteur(data);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  getTableauEleceteur(data) {
    int i = 0;
    return SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: DataTable(
            rows: data.map<DataRow>((el) {
              var element = ElecteurDTO.fromDemande(el);
              i++;
              return DataRow(
                selected: false,
                cells: [
                  // DataCell(Text('$i'), onTap: () {}, showEditIcon: true),
                  DataCell(
                      Image.network(
                          '${BackendConfig.host}/${element.photo_electeur}',
                          height: 50,
                          width: 50, errorBuilder: (context, element, er) {
                        // print(er);
                        return const Icon(
                          Icons.person,
                          size: 50,
                        );
                      }),
                      onTap: () {}),
                  DataCell(Text(element.numero_de_cni), onTap: () {}),
                  DataCell(Text(element.nom), onTap: () {}),
                  DataCell(Text(element.prenom), onTap: () {}),
                  DataCell(Text(element.email), onTap: () {}),
                  DataCell(Text(element.date_naissance), onTap: () {}),
                  DataCell(
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                    ),
                    onTap: () async {
                      await element.save3('electeur');
                      setState(() {
                        data.remove(element);
                      });
                    },
                  ),
                ],
              );
            }).toList(),
            columns: [
              // const DataColumn(label: Text('N°')),
              for (var elec in ElecteurDTO.elcteurFieldValide)
                DataColumn(
                    label: Text(
                  elec,
                )),
              DataColumn(label: Text('Action')),
            ],
            showCheckboxColumn: true,
            // headingTextStyle: const TextStyle(color: Colors.white, height: 20),
            sortColumnIndex: 5,
            sortAscending: false,
            headingRowColor: MaterialStateProperty.all(Colors.cyan),
            showBottomBorder: true,
            border: TableBorder.all(
              color: Colors.black,
              width: 1,
            )
        )
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
                    builder: (context) => MyCreateElecteur(ElecteurDTO(
                        bureau.id_section,
                        bureau.id_election,
                        bureau.id!,
                        MyHomePage.currentEMploye.id!))));
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

/*trailing: Container(child: Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 15,
            )),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.verified,
              color: Colors.green,
              size: 15,
            )),
      ],
    )*/

getListeDemandeElecteur(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    child: FutureBuilder(
        future: ElecteurDTO.getAllElecteurBySectionId(),
        builder: (context, AsyncSnapshot<http.Response> response) {
          // print(BackendConfig.curenSection!.id);
          if (response.hasError) {
            return const Text('Il y\'a eu une erreur');
          } else if (response.hasData) {
            String? a = response.data?.body;
            String b = a!;
            dynamic r = jsonDecode(b);
            int taille = r.length;
            ElecteurDTO.electeurs = [];
            // print(BackendConfig.curenSection!.id!);
            if (taille == 0) {
              return const Text('Aucune demande d\'electeur');
            }
            // Employe.liste = [];
            return ListView.builder(
              itemCount: r.length,
              itemBuilder: (BuildContext context, int index) {
                var el = ElecteurDTO.fromDemande(r[index]);
                ElecteurDTO.electeurs.add(el);
                return ElecteurButton(el);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
  );
}
