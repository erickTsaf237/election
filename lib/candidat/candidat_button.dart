import 'package:election/backend/config.dart';
import 'package:flutter/material.dart';

import '../backend/candidat.dart';
import '../backend/election.dart';
import '../backend/machine.dart';
import 'decompte.dart';

class CandidatButton extends StatefulWidget {
  static ElectionDTO? election;
  late CandidatDTO candidatDTO;
  static MachineDTO? curentMachine;

  CandidatButton(this.candidatDTO);

  @override
  State<StatefulWidget> createState() {
    return _CandidatButton(candidatDTO);
  }
}

class _CandidatButton extends State<CandidatButton> {
  late CandidatDTO candidatDTO;
  late bool voter = false;
  _CandidatButton(this.candidatDTO);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 25,
      // width: 150,
      // height: 500,
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.network(
                '${BackendConfig.host}/${candidatDTO.image}',
                fit: BoxFit.fill,
                height: 230.0,
                // width: 150,
                errorBuilder: (context, trace, tr) {
                  return Container(
                    color: Colors.white,
                    // height: 100,
                    // width: 150,
                    child: const Icon(Icons.person,
                        color: Colors.black, size: 230),
                  );
                },
              ),
              Expanded(
                  child: Container(
                // decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(225, 225, 220, 0.8))),
                color: Color.fromRGBO(225, 225, 220, 0.3),
                // height: 30,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${candidatDTO.nom} ${candidatDTO.prenom}'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '${candidatDTO.parti}: ${candidatDTO.lien}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>CandidatPage(candidatDTO)));
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            // false = user must tap button, true = tap outside dialog
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Row(children: [
                  Expanded(child: Text('${candidatDTO.nom} ${candidatDTO.prenom}'.toUpperCase()),),
                  if(voter)
                  CountDownTimer(''),
                ],),
                content: Image.network(
                    '${BackendConfig.host}/${candidatDTO.image}',width: 500,height: 350,
                    fit: BoxFit.fill, errorBuilder: (context, objet, err){
                      return Expanded(child: Container(
                        width: 500,
                        height: 350,
                        color: Colors.grey,
                      ));

                },),
                actions: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                    child: const Text('annuler'),
                    onPressed: () {
                          voter = false;
                      Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    },
                  )),
                  Expanded(
                      child: ElevatedButton(
                    child:  Text('Je vote pour ${candidatDTO.nom} ${candidatDTO.prenom}'),
                    onPressed: () {
                        CandidatButton.curentMachine!.voterLeCandidat(candidatDTO).then((value) {

                          if(value == 1)
                            Navigator.pop(context);
                            Navigator.pop(context);
                        });
                      setState(() {
                        // voter = true;
                      });
                      // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                    },
                  )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

createListeCandidat(
    BuildContext context, MachineDTO machine, List<CandidatDTO> list) {
  return Container(
      child: GridView.builder(
    itemCount: list.length,
    // Remplacez "items.length" par le nombre d'éléments que vous voulez afficher.
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: (MediaQuery.of(context).size.width >= 1300)
          ? 4
          : (MediaQuery.of(context).size.width >= 970)
              ? 3
              : 2,
      // childAspectRatio: 1, // Vous pouvez ajuster le rapport hauteur / largeur des cartes ici.
    ),
    itemBuilder: (BuildContext context, int index) {
      return CandidatButton(list[index]);
    },
  ));
}
