import 'package:election/backend/config.dart';
import 'package:election/section/section_page.dart';
import 'package:flutter/material.dart';

import '../backend/bureau_dto.dart';

class Bureau extends StatefulWidget {
  late BureauDTO bureau;
  static State? etat;

  Bureau(this.bureau);

  @override
  State<StatefulWidget> createState() {
    return _Bureau(bureau);
  }
}

class _Bureau extends State<Bureau> {
  late BureauDTO bureau;

  _Bureau(this.bureau);

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
                    child: Text('${bureau.nom}',
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 28,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                Text(
                  'de ${bureau.ville} (${bureau.localisation})',
                  style: TextStyle(
                      color: Color.fromRGBO(120, 120, 120, 7), fontSize: 20),
                ),
              ],
            ),
          ),
          onTap: () {
            BackendConfig.curenBureau = bureau;
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
                        'Voulez vous vraiment suprimer ce bureau: ${bureau.nom} ?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          var re = await bureau.delete();
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
