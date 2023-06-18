

import 'dart:convert';

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
  late List<List<String>> champElecteur;


  ElectionDTO( this.libele, this.code, this.annee, this.valeur, {this.id}){
    id_organisation = MyHomePage.currentUser.organisation!.id!;
    description = '';
    champElecteur = [['','false']];
    print(('creation'));
  }


ElectionDTO.http(data){
    libele=data['libele'];
    code=data['code'];
    annee=DateTime.parse(data['annee']);
    valeur=data['valeur'];
    description=data['description'];
    id=data['_id'];
    id_organisation = MyHomePage.currentUser.organisation!.id!;
    champElecteur = [];
    if (data['champElecteur'] != null) {
      data['champElecteur'].forEach((e){
        // champElecteur.add([]);
        List<String> list= [];
        e.forEach((a){
          list.add(a);
        });
        champElecteur.add(list);
      });

    }
    if (champElecteur.isEmpty){
      champElecteur = [['', 'false']];
    }

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
  @override
  Map<String, dynamic> toJson2() {
    // TODO: implement toJson
    return {
      '_id': id,
      'libele': libele,
      'code': code,
      'id_organisation': id_organisation,
      'valeur': valeur,
      'description': description,
      'annee': annee.toString(),
      'champElecteur': champElecteur
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