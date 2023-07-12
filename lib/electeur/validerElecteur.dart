import 'dart:convert';
import 'dart:io';

import 'package:election/backend/config.dart';
import 'package:election/backend/electeur_dto.dart';
import 'package:election/backend/election.dart';
import 'package:election/section/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';


class AfficherDemandeElecteur extends StatefulWidget {
  late ElecteurDTO electeurDTO;

  AfficherDemandeElecteur(this.electeurDTO);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AfficherDemandeElecteur(electeurDTO);
  }
}

class _AfficherDemandeElecteur extends State<AfficherDemandeElecteur> {
  late ElecteurDTO electeurDTO;
  late String demandeInvalide = '';
  late Map<String, String> donneeElecteur;
  final List<String> bureaux = [
    'Images Floue',
    'Mauvais numero de CNI',
    'Nom ou prenom different',
    'Mauvaise image',
    'Bureau 4',
    'Bureau 5',
  ];

  _AfficherDemandeElecteur(this.electeurDTO) {
    donneeElecteur = {
      'Numero de CNI': electeurDTO.numero_de_cni,
      'Nom': electeurDTO.nom,
      'Prenom': electeurDTO.prenom,
      'Date de Naissance': electeurDTO.date_naissance,
      'Email': electeurDTO.email,
      if (electeurDTO.numero.isNotEmpty) 'Numero': electeurDTO.numero,
    };
  }
  List<DataRow> getDataRow(){
    List<DataRow> a = [];
    donneeElecteur.forEach((key, value) {
      a.add(DataRow(cells: [
        DataCell(Text(key)),
        DataCell(Text(value))
      ]));
    });
    return a;
  }

  getSectionBureau(BuildContext context, String idSection, String idElection) {
    return FutureBuilder(
      future: ElectionDTO.getAllBureaufromSection(idSection, idElection),
      builder: (context, AsyncSnapshot<dynamic> reponse) {
        print(reponse);
        if (!reponse.hasError) {
          if (reponse.hasData) {
            print(reponse.data!.body);
            var data = jsonDecode(reponse.data!.body);
            return DropdownMenu(
              onSelected: (value){
                print(value.toString());
                setState(() {
                  electeurDTO.id_bureau = value.toString();
                });
              },
               dropdownMenuEntries: data.map<DropdownMenuEntry<Object>>((e) {
              return DropdownMenuEntry(
                value: e['_id'].toString(),
                label: '${e['nom'].toString()}}',
              );
            }).toList(),
            );
          }
        } else {
          print('lo pb');
        }
        return const DropdownMenu(dropdownMenuEntries: [],

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation de demande'),
      ),
      body: ListView(children: [
        //Divider(height: 3),
        SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )),
                    child: Column(
              children: [
                DataTable(
                  border: TableBorder.symmetric(),
                  columns: const [
                    DataColumn(label: Text('Attribut')),
                    DataColumn(label: Text('Valeur')),
                  ],
                  rows: getDataRow()
                )
              ],
            ))),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        )),
                    child: Column(
              children: [
                Container(
                  width: 350,
                  height: 200,
                  child: Image.network(
                      //File(electeurDTO.photo_cni_avant)

                      '${BackendConfig.host}/${electeurDTO.photo_cni_avant}',
                      fit: BoxFit.fill, errorBuilder: (context, objet, error) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 200,
                    );
                  }),
                ),
                SizedBox(height: 10,),
                Divider(height: 3),
                SizedBox(height: 10,),
                Container(
                  width: 350,
                  height: 200,
                  child: Image.network(
                      //File(electeurDTO.photo_cni_arriere)
                      '${BackendConfig.host}/${electeurDTO.photo_cni_arriere}',
                      fit: BoxFit.fill, errorBuilder: (context, objet, error) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 200,
                    );
                  }),
                )
              ],
            ))),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
                width: 2.0,
              )),
              // width: 200,
              height: 427,
              child: Image.network(
                  //File(electeurDTO.photo_electeur)
                  '${BackendConfig.host}/${electeurDTO.photo_electeur}',
                  fit: BoxFit.fill, errorBuilder: (context, objet, error) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 250,
                );
              }),
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              children: [
                DropdownMenu(
                    dropdownMenuEntries: bureaux.map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          demandeInvalide = value.toString();
                        });
                      }
                      if (kDebugMode) {
                        print('element selectionner: $value');
                      }
                    }),
                ElevatedButton(
                    onPressed: demandeInvalide.isEmpty ? null : () async {
                      electeurDTO.valide = 'invalide';
                      electeurDTO.id_employe = '';
                      var res = await electeurDTO.repondreDemande();
                      print(res.statusCode);
                      if( res.statusCode >=200 && res.statusCode < 300){
                        ElecteurDTO.electeurs.remove(electeurDTO);
                        if(ElecteurDTO.electeurs.isNotEmpty) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AfficherDemandeElecteur(ElecteurDTO.electeurs.first)));
                        }else{
                          Navigator.pop(context);
                          BackendConfig.etat?.setState(() {

                          });
                        }
                      }
                    },
                    child: const Text('Renvoyer la electeur')),
              ],
            )),
            Expanded(
                child: Column(
              children: [
                getSectionBureau(context, BackendConfig.curenSection!.id!, electeurDTO.id_election),
                ElevatedButton(
                    onPressed: (electeurDTO.id_bureau.isEmpty) ? null : () async {
                      electeurDTO.id_employe = MyHomePage.currentEMploye.id!;
                      electeurDTO.valide = 'valide';
                      print(electeurDTO);
                      var res = await electeurDTO.repondreDemande();
                      print(res.statusCode);
                      if( res.statusCode >=200 && res.statusCode < 300){
                        print('${ElecteurDTO.electeurs.length}   99999999999999999999999999');
                        ElecteurDTO.electeurs.remove(electeurDTO);
                        print('${ElecteurDTO.electeurs.length}   99999999999999999999999999');
                        if(ElecteurDTO.electeurs.isNotEmpty) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AfficherDemandeElecteur(ElecteurDTO.electeurs.last)));
                        }else{
                          Navigator.pop(context);
                          BackendConfig.etat?.setState(() {

                          });
                        }
                      }
                    },
                    child: const Text('Confirmer l\'electeur'))
              ],
            ))
          ],
        )
      ]),
    );
  }
}


