import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:election/backend/candidat.dart';
import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/candidat/create_candidat.dart';
import 'package:election/composant/MonFIle_picker.dart';
import 'package:election/election/createElection.dart';
import 'package:election/election/create_champ_electeur.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/bureau_dto.dart';
import '../backend/electeur_dto.dart';
import '../backend/election.dart';
import '../backend/employe.dart';
import '../bureau/bureau.dart';
import '../bureau/bureau_page.dart';
import '../candidat/candidat.dart';
import '../election/election.dart';
import '../employe/employe.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shimmer/shimmer.dart';


 List<CandidatDTO> candidatList = [];

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
  }

  _MyElectionPage(this.election) {
    BackendConfig.curenElectifon = election;
  }

  late String _fileName = '';

  late int tabIndex = 0;
  List<ElecteurDTO> data = [];

  void loadCsv(String fileName) async {
    // final csvString = await rootBundle.loadString(fileName);
    File file = File(fileName);
    String fileContent = await file.readAsString();
    CsvToListConverter converter =
        const CsvToListConverter(shouldParseNumbers: false);
    List<List<String>> csvTable = converter.convert(fileContent);

    // final csvString = await rootBundle.load(fileName);
    // List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
    bool listeValide = true;
    List<String> ordreElement = [];
    int i = 0;
    for (var element in ElecteurDTO.elcteurField) {
      if (!csvTable[0].contains(element)) {
        print('$election n\'a pas ete trouvé');
        listeValide = false;
        // break;
      }
      ordreElement.add(element);
      i++;
    }
    if (listeValide) {
      for (i = 1; i < csvTable.length; i++) {
        var electeurTmp = createElecteurEntity(ordreElement, csvTable[i]);
        if (electeurTmp != null) {
          setState(() {
            data.add(electeurTmp);
          });
        }
      }
    }
  }

  ElecteurDTO? createElecteurEntity(
      List ordreElement, List<dynamic> ligneFichierCsv) {
    Map<String, String> e = {
      for (int i = 0; i < ordreElement.length; i++)
        ordreElement[i]: ligneFichierCsv[i].toString(),
    };
    try {
      return ElecteurDTO.toElecteur(e);
    } catch (e) {
      print('erruer ---> createElecteurEntity');
    }
    // Map.fromIterable(iterable)
    return null;
  }

  Future<String> _openFileExplorer() async {
    List<List<dynamic>> newRows = [
      ['Dave', 40, 'Toulouse'],
      ['Eve', 45, 'Bordeaux'],
    ];

    String newCsv = const ListToCsvConverter().convert(newRows);

    final file = File('D:/data.csv');

    // Ouvre le fichier en mode append
    IOSink sink = file.openWrite(mode: FileMode.write);

    // Écrit la nouvelle chaîne CSV dans le fichier
    sink.write(newCsv);
    return '';/*FilePicker.platform
        .pickFiles(allowedExtensions: ['csv']).then((value) {
      if (value != null) {
        setState(() {
          _fileName = value.files.single.name;
          _fileName = value.files.single.path!;
        });
        print(_fileName);
      }
      return _fileName;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: getFlotting(),
        body: TabBarView(
          children: [
            getCandidatListe(context),
            getBureauListe(context),
            getListeDemandeElecteur(context)
          ],
        ),
        appBar: AppBar(
          actions: [
            if (MyHomePage.who == 'admin')
              IconButton(
                  tooltip: 'Planifiez la periode de vode',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PlanVotingDay(election);
                        });
                  },
                  icon: const Icon(Icons.update, color: Colors.blue))
          ],
          title: Text(BackendConfig.curenElectifon!.libele),
          bottom: TabBar(
            tabs: const [
              // Text('election', style: TextStyle(fontSize: 20)),
              Text('candidat', style: TextStyle(fontSize: 20)),
              Text('Bureau', style: TextStyle(fontSize: 20)),
              Text('Electeurs', style: TextStyle(fontSize: 20)),
            ],
            onTap: (int i) {
              tabIndex = i;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  getFlotting() {
    if (MyHomePage.who == 'admin') {
      if (tabIndex == 0) {
        return FloatingActionButton(
          onPressed: () async {
            _incrementCounter();
            showDialog(
                context: context,
                builder: (context) {
                  // return MyHomePage.who == 'admin' ? CreateCandidat() : CreateBureau();
                  return CreateCandidat();
                });
          },
          tooltip: 'nouveau candidat',
          child: const Icon(Icons.add),
        );
      } else if (tabIndex == 2) {
        return FloatingActionButton(
          onPressed: () async {
            _incrementCounter();
            showDialog(
                context: context,
                builder: (context) {
                  return Create_champ_Electeur(
                    candidat: election,
                  );
                });
          },
          tooltip: 'Definir les champs pour les electeurs',
          child: const Icon(Icons.add),
        );
      }
    } else if (MyHomePage.who == 'employe') {
      if (BackendConfig.curenSection!.id_responsable != null) {
        if (MyHomePage.currentEMploye.id! ==
                BackendConfig.curenSection!.id_responsable &&
            tabIndex == 1) {
          return FloatingActionButton(
            onPressed: () async {
              _incrementCounter();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CreateBureau();
                  });
            },
            tooltip: 'nouveau Bureau',
            child: const Icon(Icons.add),
          );
        }
      }
    }
    return null;
  }

  getListeElecteur() {
    int i = 0;
    return Container(
      child: data.isNotEmpty
          ? ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child: DataTable(
                  rows: data.map((element) {
                    i++;
                    return DataRow(
                      selected: false,
                      cells: [
                        // DataCell(Text('$i'), onTap: () {}, showEditIcon: true),
                        DataCell(
                            Image.file(File(element.image),
                                height: 50, width: 50,
                                errorBuilder: (context, element, er) {
                              // print(er);
                              return const Icon(
                                Icons.person,
                                size: 50,
                              );
                            }),
                            onTap: () {}),
                        DataCell(Text(element.id_election), onTap: () {}),
                        DataCell(Text(element.id_employe), onTap: () {}),
                        DataCell(Text(element.id_bureau), onTap: () {}),
                        DataCell(Text(element.id_section), onTap: () {}),
                        DataCell(Text(element.nom), onTap: () {}),
                        DataCell(Text(element.prenom), onTap: () {}),
                        DataCell(Text(element.confirmer), onTap: () {}),
                        DataCell(Text(element.email), onTap: () {}),
                        DataCell(Text(element.password), onTap: () {}),
                        DataCell(Text(element.numero_de_cni), onTap: () {}),
                        DataCell(Text(element.registration_number),
                            onTap: () {}),
                        DataCell(Text(element.date_naissance), onTap: () {}),
                        DataCell(
                          Text(element.numero),
                          onTap: () {},
                        ),
                        DataCell(
                          const Icon(Icons.verified, color: Colors.blue,),
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
                    for (var elec in ElecteurDTO.elcteurField)
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
                  columnSpacing: 15,
                  headingRowColor: MaterialStateProperty.all(Colors.cyan),
                  showBottomBorder: true,
                  border: TableBorder.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ))
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () async {
                  _fileName = await _openFileExplorer();
                  if (_fileName.isNotEmpty) {
                    loadCsv(_fileName);
                  }
                },
                child: Text('choisir un fichier'),
              ),
            ),
    );
  }

  getCandidatListe(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: CandidatDTO.getAll(),
          builder: (context, AsyncSnapshot<http.Response> response) {
            // print(response);
            if (response.hasError) {
              return Text('Il y\'a eu une erreur');
            } else if (response.hasData) {
              candidatList = [];
              String? a = response.data?.body;
              String b = a!;
              dynamic r = jsonDecode(b);
              int taille = r.length;
              return ListView(children: [
                for (int i = 0; i < taille; i++)
                  Candidat(CandidatDTO.toCandidat(r[i])),
              ]);
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: ListView(
                children: [
                  for (int i = 0; i < 10; i++)
                    ListTile(
                      title: Container(
                        width: 0,
                        color: Colors.grey,
                        height: 15,
                        child: Text(''),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                      ),
                      subtitle: Container(
                        width: 0,
                        color: Colors.grey,
                        height: 10,
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  getBureauListe(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder(
            future:
                BureauDTO.getAllByIdElection(BackendConfig.curenElectifon!.id!),
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
            }));
  }

  @override
  void initState() {
    super.initState();
    BackendConfig.etat = this;
  }
}
