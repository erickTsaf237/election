import 'package:election/backend/electeur_dto.dart';
import 'package:election/electeur/validerElecteur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../backend/config.dart';

class ElecteurButton extends StatefulWidget {
  late ElecteurDTO electeur;

  ElecteurButton(this.electeur, {super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ElecteurButton(electeur);
  }
}

class _ElecteurButton extends State {
  late ElecteurDTO electeur;

  _ElecteurButton(this.electeur);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading:
          Image.network('${BackendConfig.host}/${electeur.photo_electeur}'),
      title: Text('${electeur.nom} ${electeur.prenom}'),
      subtitle: Text('Né le: ${electeur.date_naissance.toString()}'),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AfficherDemandeElecteur(electeur)));
      },
    );
  }
}
