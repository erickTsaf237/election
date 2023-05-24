import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/backend/user.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrganisationDTO extends BackendConfig {
  late String? id;
  late String nom;
  late String code;
  late String? image;
  late String? description;
  late DateTime? createdAt;
  late DateTime? updatedAt;

  OrganisationDTO(this.nom, {required this.code}) {
    id = null;
    image = null;
    image = null;
    createdAt = null;
    updatedAt = null;
    description = '';
  }

  OrganisationDTO.http(this.id, this.nom, this.code, this.image,
      this.description, this.createdAt, this.updatedAt);

  OrganisationDTO.http2(data){
    this.id =data['_id'];
    this.nom =data['nom'];
     this.code =data['code'];
    print(data['code']);
    this.image =data['image'];
    // this.id =data[''];
    // this.id =data[''];
    this.description =data['description'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_user': MyHomePage.currentUser.id,
      'nom': nom,
      'code': code,
      'image': image ?? '',
      'description': description ?? '',
    };
  }

  @override
  Map<String, dynamic> toJson2() {
    return {
      '_id': id ?? '',
      'id_user': MyHomePage.currentUser.id,
      'nom': nom,
      'code': code,
      'image': image ?? '',
      'description': description ?? '',
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
    };
  }

  static Future<http.Response> getOrganisation(String id) async {
    return BackendConfig.getAll('organisation/user', id);
  }

  Future<bool> create() async {
    http.Response re = await save2('organisation', token: BackendConfig.token);
    if (re.statusCode >= 200 && re.statusCode < 300) {
      var a = jsonDecode(re.body);
      MyHomePage.currentUser.organisation = OrganisationDTO.http(
          a['_id'],
          a['nom'],
          a['code'],
          a['image'],
          a['description'],
          a['createdAt'] != null ? DateTime.tryParse(a['createdAt']) : DateTime
              .now(),
          a['updatedAt'] != null ? DateTime.tryParse(a['updatedAt']) : DateTime
              .now());
      return true;
    }
    return false;
  }

  static Future<http.Response> getOne(id, {autre = ''}) async {
    http.Response res;
    print('ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp');
    print(id);
    if (autre != '') {
      res = await BackendConfig.getOne('organisation', '$id/$autre');
    }
    else {
      res = await BackendConfig.getOne('organisation', id);
    }
    return res;
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
      onTap: () {},
    );
  }
}
