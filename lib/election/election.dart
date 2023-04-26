import 'package:election/backend/election.dart';
import 'package:election/election/election_page.dart';
import 'package:flutter/material.dart';

class Election extends StatefulWidget {
  late ElectionDTO election;
  static State? etat;

  Election(this.election);

  @override
  State<StatefulWidget> createState() {
    return _Election(election);
  }
}

class _Election extends State<Election> {
  late ElectionDTO election;

  _Election(this.election);

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
                    child: Text('${election.libele}',
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 28,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                Text(
                  'du ${election.annee.day} ${election.annee.month} ${election.annee.year} ',
                  style: TextStyle(
                      color: Color.fromRGBO(120, 120, 120, 7), fontSize: 20),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ElectionPage(election)));
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Suppression'),
                    content: Text(
                        'Voulez vous vraiment suprimer l\'election: ${election.libele} ?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          var re = await election.delete();
                          print(re.statusCode);
                          Navigator.pop(context);
                          Election.etat!.setState(() {});
                        },
                        child: Text('Supprimer'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                        ),

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
