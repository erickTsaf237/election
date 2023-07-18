

import 'package:election/backend/machine.dart';
import 'package:election/machine/machinePage.dart';
import 'package:flutter/material.dart';


class MachineButton extends StatefulWidget {
   late MachineDTO machineDTO;

  MachineButton(this.machineDTO);

  @override
  State<StatefulWidget> createState() {
    return _MachineButton(machineDTO);
  }
}

class _MachineButton extends State<MachineButton> {
  late MachineDTO machine;
  _MachineButton(this.machine);

  @override
  Widget build(BuildContext context) {
     return ListTile(
      leading:  CircleAvatar(
        // radius: 70,

        backgroundColor: Colors.orange,
        child:Text('${machine.nom[0]}${machine.prenom[0]}'.toUpperCase()),
      ),
      title: Text(
        '${machine.nom} ${machine.prenom}'.toUpperCase(),
        style: const TextStyle(
          fontSize: 25.0,
        )
      ),
       subtitle: Text(machine.createdAt.toIso8601String(),),
       onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>MachinePage(machine)));
       },

    );
    return Container(
      // height: 25,
      width: 150,
      // height: 500,
      child: InkWell(child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
             Container(
                  color: Colors.white,
                  height: 100,
                  width: 150,
                  child: const Icon(Icons.person, color: Colors.black,size: 120),


            ),
            Container(
              // decoration: BoxDecoration(border: Border.all(color: const Color.fromRGBO(225, 225, 220, 0.8))),
              color: Color.fromRGBO(225, 225, 220, 0.3),
              // height: 30,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${machine.nom} ${machine.prenom}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${machine.id}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MachinePage(machine)));
        },
      ),
    );
  }
}
