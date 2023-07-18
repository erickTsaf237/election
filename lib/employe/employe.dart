
import 'package:election/backend/config.dart';
import 'package:election/main.dart';
import 'package:election/section/section_page.dart';
import 'package:flutter/material.dart';

import '../backend/employe.dart';

class Employe extends StatefulWidget {
  late EmployeDTO election;
  static List<EmployeDTO> liste=[];
  static State? etat;

  Employe(this.election);

  @override
  State<StatefulWidget> createState() {
    return _Section(election);
  }
}

class _Section extends State<Employe> {
  late EmployeDTO employe;

  _Section(this.employe);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
          child:ListTile(title: Text('${employe.nom} ${employe.prenom} ${employe.estChef(BackendConfig.curenSection!.id_responsable)? '(chef)':''}'),
          subtitle: Text(DateTime.now().difference(DateTime.parse(employe.date_naissance)).inDays.toString()),
          trailing: MyHomePage.who == 'admin'?PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(child:const ListTile(leading: Icon(Icons.delete), title:Text('supprimer') ,),onTap: () async {
                Navigator.pop(context);
                // print('object');
                boo(context);
                boo(context);
            }),
              PopupMenuItem(child:const ListTile(leading: Icon(Icons.upgrade), title:Text('definir chef') ,), onTap: (){
                definirChef(context);
                definirChef(context);
              },),
              PopupMenuItem(child:const ListTile(leading: Icon(Icons.info), title:Text('Affcher ID') ,), onTap: (){
                afficherInfo(context);
                afficherInfo(context);
              },)
            ];
          }):null,
          // trailing: Text(election.id==BackendConfig.curenSection!.id_responsable!?'chef':'', style: TextStyle(color: Colors.lightBlueAccent),),
          ),
          onTap: () {
            // BackendConfig.curenSection = election;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SectionePage()));
          },
          onLongPress: () {
          }),
    );
  }

  boo(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Suppression'),
            content: Text(
                'Voulez vous vraiment suprimer la section: ${employe.nom} ?'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  var re = await employe.delete();
                  print(re.statusCode);
                  Navigator.pop(context);
                  Employe.etat!.setState(() {});
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
                  child: const Text('Annuler')),
            ],
          );
        });
  }

  definirChef(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Nouveau chef de section'),
            content: Text(
                'Voulez vous vraiment rendre ${employe.nom} ${employe.prenom} la section: ${BackendConfig.curenSection!.nom} ?'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  BackendConfig.curenSection!.id_responsable = employe.id!;
                  var re = await BackendConfig.curenSection!.updateMe();
                  // print(re.statusCode);
                  Navigator.pop(context);
                  Employe.etat!.setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text('rendre chef'),

              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler')),
            ],
          );
        });
  }


  afficherInfo(BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${employe.nom} ${employe.prenom}'),
            content: SelectableText(
                'Identifiant: ${employe.id} ', ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Employe.etat!.setState(() {});
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text('Ok'),

              ),
            ],
          );
        });
  }
}


