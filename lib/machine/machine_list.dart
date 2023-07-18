import 'dart:convert';

import 'package:election/backend/bureau_dto.dart';
import 'package:election/backend/machine.dart';
import 'package:election/machine/machine_button.dart';
import 'package:flutter/material.dart';

class MachineList extends StatefulWidget {
  late BureauDTO bureau;

  MachineList(this.bureau);

  @override
  State<StatefulWidget> createState() {
    return _MachineList(bureau);
  }
}

class _MachineList extends State<MachineList> {
  late BureauDTO bureau;

  _MachineList(this.bureau);

  @override
  Widget build(BuildContext context) {
    return getListeMachine(context, bureau.id!);
  }

}


getListeMachine(BuildContext context, id_bureau) {
  return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: MachineDTO.getAllByIdBureau(id_bureau),
          builder: (context, AsyncSnapshot<dynamic> response) {
            if (response.hasError) {
              return const Text('Il y\'a eu une erreur');
            } else if (response.hasData) {
              String? a = response.data?.body;

              String b = a!;
              dynamic r = jsonDecode(b);
              int taille = r.length;
              if (taille == 0) {
                return const Text(
                    'Ce bureau N\'a pas de Machine a voter');
              }
              // Employe.liste = [];
              return ListView(children: [
                for (int i = 0; i < taille; i++)
                  MachineButton(MachineDTO.http(r[i])),
              ]);
            }
            return const CircularProgressIndicator();
          }));
}