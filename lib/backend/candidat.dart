import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/composant/accueille.dart';
import 'package:election/main.dart';
import 'package:http/http.dart' as http;

class CandidatDTO extends BackendConfig{

  late String? id;
  late String nom;
  late String prenom;
  late String parti;
  late String lien;
  late DateTime date_naissance;
  late String id_election;


  CandidatDTO(
      {
        required this.nom,
        required this.prenom,
        required this.parti,
        this.id,
      }){
    id_election = BackendConfig.curenElectifon!.id!;
    date_naissance = DateTime.now();
    lien = '';
    id = '';
  }

  Map<String, dynamic> toJson(){
    return id!=''? {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'lien': lien,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    }:{
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'lien': lien,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    };
  }

  @override
  Map<String, dynamic> toJson2(){
    return {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'parti': parti,
      'lien': lien,
      'id_election': id_election,
      'date_naissance': date_naissance.toString(),
    };
  }

  static CandidatDTO toCandidat(Map<String, dynamic> re){
    return CandidatDTO(nom: re['nom'], prenom: re['prenom'], parti: re['parti'], id: re['_id']);
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


}