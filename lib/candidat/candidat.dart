


import 'package:election/backend/config.dart';
import 'package:election/backend/election.dart';
import 'package:election/candidat/create_candidat.dart';
import 'package:election/election/election_page.dart';
import 'package:flutter/material.dart';

import '../backend/candidat.dart';

class Candidat extends StatefulWidget {
  late CandidatDTO candidat;

  Candidat(this.candidat){
    candidatList.add(candidat);
  }

  @override
  State<StatefulWidget> createState() {
    return _Candidat(candidat);
  }
}

class _Candidat extends State<Candidat> {
  late CandidatDTO candidat;

  _Candidat(this.candidat);

  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child:InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: EdgeInsets.all(5),
          // decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
          child: Row(children: [
            Container(
              padding: EdgeInsets.only(right: 15),
              child: candidat.image.isNotEmpty?
            CircleAvatar(radius: 40,

              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('${BackendConfig.host}/${candidat.image}'),
            ):
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange,
              child: Text('${candidat.nom[0].toUpperCase()}${candidat.prenom[0].toUpperCase()}'),
            ),),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Title(
                    color: Colors.red,
                    child: Text('${candidat.nom} ${candidat.prenom}',
                        style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 28,
                            fontStyle: FontStyle.italic)),
                  ),),
                Text(
                  'du ${candidat.parti}', style:  const TextStyle(color: Color.fromRGBO(120, 120, 120, 7), fontSize: 20),),
              ],

            ))
          ],),
        ),
        onTap:() {

          showDialog(context: context, builder: (context)=> CreateCandidat(candidat: candidat));
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCandidat(candidat: candidat,)));
        },

      ),
    );
  }
}
