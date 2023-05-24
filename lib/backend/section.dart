

import 'package:election/main.dart';
import 'package:http/http.dart' as http;


import 'config.dart';

class SectionDTO extends BackendConfig{


  late String? id;
  late String nom;
  late String ville;
  late String categorie;
  late String localisation;
  late String? id_responsable;
  late String description;
  late String id_organisation;


  SectionDTO( this.nom, this.ville, this.categorie, this.localisation, {this.id, this.id_responsable=''}){
    id_organisation = MyHomePage.currentUser.organisation!.id!;
    description = '';
  }


  SectionDTO.http(data){
    nom=data['nom'];
    ville=data['ville'];
    categorie=data['categorie'];
    // categorie=DateTime.parse(data['annee']);
    localisation=data['localisation'];
    description=data['description'];
    id_organisation=data['id_organisation']??'';
    id_responsable = data['id_responsable']??'';
    id=data['_id'];
    id_organisation = MyHomePage.currentUser.organisation!.id!;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      // '_id': id??'',
      'nom': nom,
      'ville': ville,
      'id_organisation': id_organisation,
      'localisation': localisation,
      'description': description,
      'categorie': categorie
    };
  }

  updateMe(){
    return update('section');
  }

  @override
  Map<String, dynamic> toJson2() {
    // TODO: implement toJson
    return {
      '_id': id,
      'nom': nom,
      'ville': ville,
      'id_organisation': id_organisation,
      'localisation': localisation,
      'description': description,
      'id_responsable': id_responsable,
      'categorie': categorie
    };
  }

  Future<http.Response>  delete() async {

    // await BackendConfig.delete('section/election', id!);
    return await BackendConfig.delete('section', id!);
  }

  static getAll(){
    return BackendConfig.getAll('section/organisation', MyHomePage.currentUser.organisation!.id!);
  }

  static Future<http.Response> getOne(id, {autre=''}) async{
    http.Response res;
    if(autre != ''){
      res = await BackendConfig.getOne('section', '$id/$autre');
    }
    else {
      res = await BackendConfig.getOne('section', id);
    }
    return res;
  }

}