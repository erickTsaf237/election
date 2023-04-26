

import 'package:election/backend/config.dart';
import 'package:election/backend/user.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrganisationDTO extends BackendConfig{

  late String? id;
  late String nom;
  late String code;
  late String? image;
  late String? description;
  late DateTime? createdAt;
  late DateTime? updatedAt;
 OrganisationDTO(this.nom, {required this.code}){
   id=null;
   image=null;
   image = null;
   createdAt = null;
   updatedAt = null;
   description = '';
 }


  OrganisationDTO.http(this.id, this.nom, this.code, this.image, this.description,
      this.createdAt, this.updatedAt);

  @override
  Map<String, dynamic>toJson() {
    return {
      'id': id??'',
      'id_user': MyHomePage.currentUser.id,
      'nom': nom,
      'code': code,
      'image': image??'',
      'description': description??'',
      'createdAt': createdAt??'',
      'updatedAt': updatedAt??'',
    };
  }

  static Future<http.Response> getOrganisation(String id) async {
    return BackendConfig.getAll('organisation/user', id);
  }
}

class Organisation extends StatelessWidget {

  late OrganisationDTO organisation;


  Organisation(this.organisation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      tileColor: const Color(0x00ff0012),
      title: Text(organisation.nom),
      onTap: (){

      },
    );

  }


}