import 'package:election/backend/bureau_dto.dart';
import 'package:election/backend/config.dart';
import 'package:election/bureau/bureau.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../backend/employe.dart';
import '../backend/machine.dart';

class CreateMachine extends StatefulWidget {
  late BureauDTO bureau;

  CreateMachine(this.bureau);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateMachine(bureau);
  }
}

class _CreateMachine extends State<CreateMachine> {
  late BureauDTO bureau;
  late MachineDTO machine;
  List<EmployeDTO> list=[];
  int selectedIndex = 0;
  String message = '';

  _CreateMachine(this.bureau) {
    machine =
        MachineDTO('', bureau.id!, '', bureau.id_election, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: const Text('Nouveau membre du bureau'),
      content: Container(
        height: 275,
        child: Column(
          children: [
            if(message.isNotEmpty)
            Text(message),
            const SizedBox(height: 10,),
            getEmployeDiponible(context),
            const SizedBox(height: 25,),
            ElevatedButton(
                onPressed: machine.id_employe.isEmpty ? null : () {
                  machine.saveMachine().then((value){
                    print(value);
                    if(value){
                      Navigator.pop(context);
                      Bureau.etat?.setState(() {});
                    }else{
                      setState(() {
                        message = 'Echec d\'ajout du membre';
                      });
                    }
                  });
                },
                child: const Text('Ajouter')),
          ],
        ),
      ),
    );
  }

  getEmployeDiponible(BuildContext context) {
    return FutureBuilder(
        future: EmployeDTO.getAllFree(),
        builder: (context, AsyncSnapshot<List<EmployeDTO>> response2) {
          if (response2.data != null) {
            list  = response2.data!;
            selectedIndex = -1;
            print(list.length);
            return DropdownButtonFormField(
              items: list.map<DropdownMenuItem<String>>((e) {
                selectedIndex++;
                return DropdownMenuItem(
                  value: selectedIndex.toString(),
                  child: Text('${e.nom} ${e.prenom}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedIndex = int.parse(value.toString());
                  machine.id_employe = list[selectedIndex].id!;
                  machine.nom = list[selectedIndex].nom;
                  machine.prenom = list[selectedIndex].prenom;

                });
              },
              decoration:
                  const InputDecoration(labelText: 'Membre du Bureau de vote'),
            );
          }
          return const Text('Aucun employe de disponible');
        });
  }
}
