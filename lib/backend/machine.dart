import 'dart:convert';

import 'package:election/backend/candidat.dart';
import 'package:election/main.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class MachineDTO extends BackendConfig {
  late String? id;
  late String id_bureau;
  late String id_employe;
  late String id_election;
  late String id_electeur;
  late String nom;
  late String prenom;
  late DateTime createdAt;


  MachineDTO(this.id, this.id_bureau, this.id_employe, this.id_election,
      this.createdAt, {this.id_electeur='', });

  MachineDTO.http(data) {
    id = data['_id']??'';
    id_bureau = data['id_bureau'];
    id_employe = data['id_employe'];
    nom = data['nom'];
    prenom = data['prenom'];
    createdAt=data['createdAt']!=null?DateTime.parse(data['createdAt']):DateTime.now();
    id_election = data['id_election']??'';
    id_electeur = data['id_electeur']??'';
  }
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      // '_id': id??'',
      'id_bureau': id_bureau,
      'id_employe': id_employe,
      if(id_electeur.isNotEmpty)
      'id_electeur': id_electeur,
      'prenom': prenom,
      'nom': nom,
      'createdAt': createdAt.toString(),
      'id_election': id_election,
    };
  }

  updateMe() {
    return update('machine');
  }

  @override
  Map<String, dynamic> toJson2() {
    // TODO: implement toJson
    return {
      '_id': id,
      'id_bureau': id_bureau,
      'id_employe': id_employe,
      'id_electeur': id_electeur,
      'nom': nom,
      'prenom': prenom,
      'createdAt': createdAt.toString(),
      'id_election': id_election,
    };
  }

  Future<bool> saveMachine() async {
    http.Response a = await save2('machine');
    print(a.statusCode);
    if(a.statusCode>=200 && a.statusCode < 300){
      return true;
    }
    return false;
  }

  Future<http.Response> delete() async {
    // await BackendConfig.delete('section/election', id!);
    return await BackendConfig.delete('machine', id!);
  }

  static Future<http.Response> employeIsFree(String id){
    return BackendConfig.getAll(
        'bureau/free/employe/${BackendConfig.curenElectifon!.id}', id);
  }

  static Future<http.Response> getAll() {
    print('${BackendConfig.curenElectifon!.id!} eeeeeeeeee');
    return BackendConfig.getAll(
        'machine/election', BackendConfig.curenElectifon!.id!);
  }

  static getAllByIdElection(String idElection) {
    if (MyHomePage.who == 'admin'){
      return  BackendConfig.getAll(
          'machine/election', idElection);
    }
    return BackendConfig.getAll(
        'machine/section/election/${BackendConfig.curenSection!.id!}', idElection);
  }
  static getAllByIdBureau(String id_bureau) {
    return  BackendConfig.getAll(
        'machine/bureau', id_bureau);
  }

  static Future<http.Response> getOne(id, {autre = ''}) async {
    http.Response res;
    if (autre != '') {
      res = await BackendConfig.getOne('machine', '$id/$autre');
    } else {
      res = await BackendConfig.getOne('machine', id);
    }
    return res;
  }

  Future<int>isMachineReady(String id_employe)  async {
    print('${BackendConfig.host}/machine/machineIsReady/$id/${id_employe}');
    http.Response a = await http.get(Uri.parse('${BackendConfig.host}/machine/machineIsReady/$id/${id_employe}'));
    print(a.statusCode);
    if(a.statusCode >= 200 && a.statusCode < 300){
      print('${a.body}    **********************');
      var body = jsonDecode(a.body);
      return body == true?1:0;
    }
    else if(a.statusCode >= 400 && a.statusCode < 500){
      return 400;
    }else if(a.statusCode >= 500 && a.statusCode < 600){
      return 500;
    }
    return -1;
  }


  Future<int> voterLeCandidat(CandidatDTO candida) async {
    return await http.post(Uri.parse('${BackendConfig.host}/vote/machine'),
        body: {
          'id_machine':id!,
          'id_election':id_election,
          'id_bureau':id_bureau,
          'id_candidat':candida.id!,
        }
    ).then((value) {
      if (value.statusCode >=200 && value.statusCode < 300){
        print('vote ${value.body}');
        if(jsonDecode(value.body)!=null){
          return 1;
        }
        return 0;
      }
      return 400;
    });
  }
}
