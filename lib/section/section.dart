import 'package:election/backend/config.dart';
import 'package:election/backend/election.dart';
import 'package:election/election/election_page.dart';
import 'package:election/section/section_page.dart';
import 'package:flutter/material.dart';

import '../backend/section.dart';

class Section extends StatefulWidget {
  late SectionDTO election;
  static State? etat;

  Section(this.election);

  @override
  State<StatefulWidget> createState() {
    return _Section(election);
  }
}

class _Section extends State<Section> {
  late SectionDTO election;

  _Section(this.election);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: EdgeInsets.all(5),
            // decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Title(
                    color: Colors.red,
                    child: Text('${election.nom}',
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 28,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                Text(
                  'de ${election.ville} (${election.localisation}) categorie ${election.categorie}',
                  style: TextStyle(
                      color: Color.fromRGBO(120, 120, 120, 7), fontSize: 20),
                ),
              ],
            ),
          ),
          onTap: () {
            BackendConfig.curenSection = election;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SectionePage()));
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Suppression'),
                    content: Text(
                        'Voulez vous vraiment suprimer la section: ${election.nom} ?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          var re = await election.delete();
                          print(re.statusCode);
                          Navigator.pop(context);
                          BackendConfig.etat!.setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Text('Supprimer'),

                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Annuler')),
                    ],
                  );
                });
          }),
    );
  }
}
