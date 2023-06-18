import 'package:election/main.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class BureauDTO extends BackendConfig {
  late String? id;
  late String nom;
  late String ville;
  late String password;
  late String localisation;
  late String id_responsable;
  late String description;
  late String id_section;
  late String id_chef_section;
  late String id_election;
  late DateTime createdAt;
  late List<String> id_employes;

  BureauDTO(this.id_chef_section, this.id_section, this.ville, this.nom,
      this.password, this.localisation, this.id_responsable,
      {this.id, this.description=''}) {
    id_election = BackendConfig.curenElectifon!.id!;
    createdAt = DateTime.now();
    description = '';
    id_employes = [];
  }

  BureauDTO.http(data) {
    nom = data['nom'];
    ville = data['ville'];
    password = data['password'];
    createdAt=DateTime.parse(data['createdAt']);
    localisation = data['localisation'];
    description = data['description'];
    id_section = data['id_section'] ?? '';
    id_election = data['id_election'] ?? '';
    id_responsable = data['id_responsable'] ?? '';
    id_chef_section = data['id_chef_section'];
    /*id_employes =*/ //data['id_employes'].map((e){
    var a =  data['id_employes'].map((e){
      print('object');
      return e.toString();
    });
    //   return e.toString();
    // }).toList();
    id = data['_id'];
  }
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      // '_id': id??'',
      'nom': nom,
      'ville': ville,
      'password': password,
      'createdAt': createdAt.toString(),
      'id_section': id_section,
      'id_election': id_election,
      'id_chef_section': id_chef_section,
      'id_responsable': id_responsable,
      'localisation': localisation,
      'description': description,
      'id_employes': id_employes
    };
  }

  updateMe() {
    return update('section');
  }

  @override
  Map<String, dynamic> toJson2() {
    // TODO: implement toJson
    return {
      '_id': id,
      'nom': nom,
      'ville': ville,
      'password': password,
      'createdAt': createdAt.toString(),
      'id_section': id_section,
      'id_chef_section': id_chef_section,
      'id_election': id_election,
      'id_responsable': id_responsable,
      'localisation': localisation,
      'description': description,
      'id_employes': id_employes
    };
  }

  Future<http.Response> delete() async {
    // await BackendConfig.delete('section/election', id!);
    return await BackendConfig.delete('bureau', id!);
  }

  static Future<http.Response> employeIsFree(String id){
    return BackendConfig.getAll(
        'bureau/free/employe/${BackendConfig.curenElectifon!.id}', id);
  }

  static Future<http.Response> getAll() {
    print('${BackendConfig.curenSection!.id!} eeeeeeeeee');
    return BackendConfig.getAll(
        'bureau/section', BackendConfig.curenSection!.id!);
  }

  static getAllByIdElection(String idElection) {
    if (MyHomePage.who == 'admin'){
      return  BackendConfig.getAll(
          'bureau/election', idElection);
    }
    return BackendConfig.getAll(
        'bureau/section/election/$idElection', BackendConfig.curenSection!.id!);
  }

  static Future<http.Response> getOne(id, {autre = ''}) async {
    http.Response res;
    if (autre != '') {
      res = await BackendConfig.getOne('section', '$id/$autre');
    } else {
      res = await BackendConfig.getOne('section', id);
    }
    return res;
  }
}
