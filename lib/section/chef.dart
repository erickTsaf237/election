

import 'package:election/backend/section.dart';
import 'package:flutter/material.dart';

class Chef extends StatefulWidget{
  late SectionDTO section;

  Chef(this.section);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }



}

class _Chef extends State<Chef>{
  late SectionDTO section;

  _Chef(this.section);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('${section.nom}'),
      content: Container(
        child: ListTile(title: Text('a ne pas valider'),),
      ),
    );
  }
}