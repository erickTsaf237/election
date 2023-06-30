import 'dart:convert';
import 'dart:io';

import 'package:election/backend/config.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/composant/accueille.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CandidatDTO extends BackendConfig{

  late String? id;
  late String nom;
  late String prenom;
  late String parti;
  late String lien;
  late String image;
  late File? image2;
  late DateTime date_naissance;
  late String id_election;

  Future<String?> prepareFileToSend() async {
    if(image2 != null) {
      final byte = await image2?.readAsBytes();
      final base64Imqge = base64Encode(byte!);
      print(base64Imqge);
      return base64Imqge;
    }
    return '';
  }


  @override
  String toString() {
    return 'CandidatDTO{id: $id, nom: $nom, prenom: $prenom, parti: $parti, lien: $lien, image: $image, date_naissance: $date_naissance, id_election: $id_election}';
  }

  CandidatDTO(
      {
        required this.nom,
        required this.prenom,
        required this.parti,
        this.id='',
        this.image = ''
      }){
    id_election = BackendConfig.curenElectifon!.id!;
    date_naissance = DateTime.now();
    lien = '';

  }

  Future<Map<String, dynamic>> toJson() async {
    // var image2 = await prepareFileToSend();
    return id!=''? {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'lien': lien,
      'image':  image,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    }:{
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'image':  image,
      'lien': lien,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    };
  }

  @override
  Future<Map<String, dynamic>> toJson2() async {
    // var image2 = await prepareFileToSend();
    return {
      '_id': id!,
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'lien': lien,
      'image':  image,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    };
  }

  static CandidatDTO toCandidat(Map<String, dynamic> re){
    return CandidatDTO(nom: re['nom'], prenom: re['prenom'], parti: re['parti'], id: re['_id'], image: re['image']??'' );
  }

  // CandidatDTO.http(re){
  //
  // }

  static getAll(){
    return BackendConfig.getAll('candidat/election', BackendConfig.curenElectifon!.id!);
  }


  static Future<bool> isloged(http.Response response, {token = ''}) async {
    // TODO before use
    throw UnimplementedError();
    print(response.body);

    if(response.statusCode >=200 && response.statusCode <300){
      // BackendConfig.token = jsonDecode(response.body)['code'];
      if(token!='') {
        var token = jsonDecode(response.body);
        // MyHomePage.currentUser = toCandidat(token['user']);
        await getOrg();
        print(token);
        BackendConfig.token = token['access_token'];
      }else{
        var res = jsonDecode(response.body);
        BackendConfig.token = res['code'];
      }

      return true;
    }
    return false;
  }





  Future<bool> logup() async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/user"),
        headers: <String, String>{
          'Content-Type': 'application/json'
        },
        body: jsonEncode(toJson())
    );
    // return await logUserIn(res);
    print(res.body);
    return true;
  }

  Future<bool> logCandidatIn(http.Response response) async {

    if(response.statusCode >= 200 && response.statusCode < 300){
      // return await log_in(login, password);
    }
    // TODO : il faut gerrer le cas d'erreur
    return false;
  }

  static logout(){
    BackendConfig.token = '';
  }

  static Future<bool>log_in(login, password) async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/auth"), headers: <String, String>{
      'Content-Type': 'application/json'
    },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password
        })
    );
    return await isloged(res);
  }
  static Future<bool> confirmToken(login, password, token) async {
    print(login +' '+ password+ ' '+ token);
    final res = await http.post(Uri.parse("${BackendConfig.host}/auth/activate"), headers: <String, String>{
      'Content-Type': 'application/json'
    },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'token': token
        })
    );
    return isloged(res, token: token);
  }

  Future<bool> deleteCandidat() async {
    http.Response re =await  BackendConfig.delete('candidat', id!);
    if (re.statusCode >= 200 && re.statusCode <= 300) {
      return true;
    }
    return false;

  }


}