

import 'package:election/main.dart';
import 'package:http/http.dart' as http;


import 'config.dart';

class ElectionDTO extends BackendConfig{


  late String? id;
  late String libele;
  late String code;
  late String description;
  late String id_organisation;
  late DateTime annee;
  late int valeur;


  ElectionDTO( this.libele, this.code, this.annee, this.valeur, {this.id}){
    id_organisation = MyHomePage.currentUser.organisation!.id!;
    description = '';
  }

  /*ElectionDTO.or(){
    libele='Election du delegue de QSIR et de ses adjoins';
    code='le code';
    annee=DateTime.now();
    valeur=5;
    description='le libelele libelele libelele libelele libelele libelele libelele libelele libelele libele';
    id_organisation = MyHomePage.currentUser.organisation!.id!;
}*/

ElectionDTO.http(data){
    libele=data['libele'];
    code=data['code'];
    annee=DateTime.parse(data['annee']);
    valeur=data['valeur'];
    description=data['description'];
    id=data['_id'];
    id_organisation = MyHomePage.currentUser.organisation!.id!;
}

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      // '_id': id??'',
      'libele': libele,
      'code': code,
      'id_organisation': id_organisation,
      'valeur': valeur,
      'description': description,
      'annee': annee.toString()
    };
  }

  Future<http.Response>  delete() async {

    await BackendConfig.delete('candidat/election', id!);
    return await BackendConfig.delete('election', id!);
  }

  static getAll(){
    return BackendConfig.getAll('election/organisation', MyHomePage.currentUser.organisation!.id!);
  }

}