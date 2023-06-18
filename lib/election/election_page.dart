import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:election/backend/candidat.dart';
import 'package:election/backend/config.dart';
import 'package:election/bureau/create_bureau.dart';
import 'package:election/candidat/create_candidat.dart';
import 'package:election/composant/MonFIle_picker.dart';
import 'package:election/election/create_champ_electeur.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/bureau_dto.dart';
import '../backend/election.dart';
import '../backend/employe.dart';
import '../bureau/bureau.dart';
import '../candidat/candidat.dart';
import '../election/election.dart';
import '../employe/employe.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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
  List<List<dynamic>> data = [];

  void loadCsv(String fileName) async {
    // final csvString = await rootBundle.loadString(fileName);
    File file = File(fileName);
    String fileContent = await file.readAsString();
    CsvToListConverter converter = CsvToListConverter();
    List<List<dynamic>> csvTable = converter.convert(fileContent);
    // final csvString = await rootBundle.load(fileName);
    // List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
    setState(() {
      data = csvTable;
      print(data);
    });
  }

  Future<String> _openFileExplorer()  async {
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
    return  FilePicker.platform.pickFiles(allowedExtensions: ['csv']).then((value) {
      if (value != null) {
        setState(() {
          _fileName = value.files.single.name;
          _fileName = value.files.single.path!;
        });
        print(_fileName);
      }
      return _fileName;
    });
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
            getListeElecteur()
          ],
        ),
        appBar: AppBar(
          title: Text(BackendConfig.curenElectifon!.libele),
          bottom: TabBar(
            tabs: const [
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

  getListeElecteur(){
    return Container(
      child:data.isNotEmpty?
      SingleChildScrollView(
          child: DataTable(rows: [
            for(var eles in data)
              DataRow(cells: [
                for(var ele in eles)
                  DataCell(Text('$ele'), onTap: (){}),
              ], ),

          ], columns: [
            for(var elec in election.champElecteur)
              DataColumn(label: Text(elec[0]))
          ],
          ))
          :Center(
        child: ElevatedButton(
          onPressed: () async {
            _fileName = await _openFileExplorer();
            if(_fileName.isNotEmpty) {
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
