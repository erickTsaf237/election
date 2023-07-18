import 'dart:convert';

import 'package:election/backend/bureau_dto.dart';
import 'package:election/backend/config.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/backend/section.dart';
import 'package:election/backend/user.dart';
import 'package:election/employe/employe.dart';
import 'package:election/main.dart';
import 'package:http/http.dart' as http;

class EmployeDTO extends BackendConfig {
  late String? id;
  late String nom;
  late String prenom;
  late String login;
  late String numero;
  late String confirmer;
  late String password;
  late String date_naissance;
  late String id_section;

  EmployeDTO(this.nom, this.prenom, this.login, this.numero, this.confirmer,
      this.password,
      {this.id = '', this.date_naissance = '', this.id_section = ''}) {
    // id_section = BackendConfig.curenSection != null
    //     ? BackendConfig.curenSection!.id!
    //     : '45454';
    date_naissance == ''
        ? date_naissance = DateTime.now().toString()
        : date_naissance = DateTime.now().toString();
  }

  bool estChef(String? id_chef) {
    if (id_chef == null) {
      return false;
    } else if (id_chef.isEmpty) {
      return false;
    }
    return id! == id_chef;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'confirmer': confirmer,
      'login': login,
      'password': password,
      'date_naissance': date_naissance,
      'id_section': id_section
    };
  }

  static createCurentOrganisationAndUser(EmployeDTO e) async {
    //cette fonction a pour role de definr un employe comme utilisateur et de recuperer l'organisation dans
    //laquelle il est membre

    //on regupere la section
    var res = await SectionDTO.getOne(e.id_section);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        var a = jsonDecode(res.body);
        //on regupere ensuite l'organisation
        res = await OrganisationDTO.getOne(a['id_organisation']);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          var b = jsonDecode(res.body);
          // on creer un utilisatuer avec les informations de l'employe
          MyHomePage.currentUser = UserBackend(
              nom: e.nom,
              prenom: e.prenom,
              login: e.login,
              numero: e.numero,
              confirmer: 'confirmer',
              password: e.password);
          MyHomePage.currentUser.organisation = OrganisationDTO.http2(b);
          BackendConfig.curenSection = SectionDTO.http(a);
          return true;
        }
      } catch (e) {
        print(e);
      }
      return false;
    }
  }

  @override
  Map<String, dynamic> toJson2() {
    return {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'login': login,
      'numero': numero,
      'confirmer': confirmer,
      'password': password,
      'date_naissance': date_naissance,
      'id_section': id_section
    };
  }

  static EmployeDTO toEmploye(Map<String, dynamic> re, {add = true}) {
    var emp = EmployeDTO(re['nom'], re['prenom'], re['login'] ?? '',
        re['numero'] ?? '', '', re['password'],
        id: re['_id'],
        date_naissance: re['date_naissance'],
        id_section: re['id_section'] ?? '4545');
    if (add) Employe.liste.add(emp);
    return emp;
  }



  // getFreeEmployeList() async {
  //   http.Response a = await EmployeDTO.getAll();
  //   var b = jsonDecode(a.body);
  //   b.map((e){
  //
  //   })
  // }

  static Future<bool> isloged(http.Response response, {token = ''}) async {
    print(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // BackendConfig.token = jsonDecode(response.body)['code'];
      if (token != '') {
        var token = jsonDecode(response.body);
        // MyHomePage.currentUser = toUser(token['user']);
        // await getOrg();
        print(token);
        BackendConfig.token = token['access_token'];
      } else {
        var res = jsonDecode(response.body);
        BackendConfig.token = res['code'];
      }

      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'UserBackend{id: $id, nom: $nom, prenom: $prenom, login: $login, numero: $numero, confirmer: $confirmer, password: $password}';
  }

  static Future<bool> logup(id, pass, login, numero) async {
    final res = await http.put(Uri.parse("${BackendConfig.host}/employe"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            {'_id': id, 'password': pass, 'login': login, 'numero': numero}));
    // return await logUserIn(res);
    print(res.body);
    return true;
    // return await logUserIn(res);
    // return res;
    // return isloged(res);
  }

  Future<bool> logUserIn(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return await log_in(login, password);
    }
    // TODO : il faut gerrer le cas d'erreur
    return false;
  }

  static logout() {
    BackendConfig.token = '';
  }

  static Future<bool> log_in(login, password) async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/auth"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body:
            jsonEncode(<String, String>{'login': login, 'password': password}));
    return await isloged(res);
  }

  static Future<bool> confirmToken(login, password, token) async {
    print(login + ' ' + password + ' ' + token);
    final res = await http.post(
        Uri.parse("${BackendConfig.host}/auth/activate"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'token': token
        }));
    return isloged(res, token: token);
  }

  Future<http.Response> delete() async {
    // await BackendConfig.delete('candidat/election', id!);
    return await BackendConfig.delete('employe', id!);
  }

  static getAll() {
    return BackendConfig.getAll(
        'employe/section', BackendConfig.curenSection!.id!);
  }


  static Future<List<EmployeDTO>> getAllFree() async {
    http.Response all = await BackendConfig.getAll(
        'employe/section', BackendConfig.curenSection!.id!);
    var allDecode = jsonDecode(all.body);
    List<EmployeDTO> list = [];
    for(var i=0; i < allDecode.length; i++){
      var element = allDecode[i];
      EmployeDTO employe = toEmploye(element);
      var isFree = await BureauDTO.employeIsFree(employe.id!);
      if(isFree.body == 'true'){
        list.add(employe);
      }
    }
    return list;
    /*return await allDecode.map((emp) async {
      EmployeDTO employe = toEmploye(emp);
      bool isFree = await BureauDTO.employeIsFree(employe.id!).then((value) {

        return value.body == false?false:false;
      });
      return isFree?employe:null;
    }).toList();*/

  }

  static isFree() {
    // BureauDTO.
    return BackendConfig.getAll(
        'employe/section', BackendConfig.curenSection!.id!);
  }


  static getOne(id, {autre = ''}) async {
    http.Response res;
    if (autre != '') {
      res = await BackendConfig.getOne('employe', '$id/$autre');
    } else {
      res = await BackendConfig.getOne('employe', id);
    }
    return res;
  }

  Future<bool> setElecteurIdIntoMyMyMachine( String electionId, String electeurId) async {
    var a = await http.put(Uri.parse('${BackendConfig.host}/machine/employe/election/electeur/$id/$electionId/$electeurId'));
      print('${BackendConfig.host}/machine/employe/election/electeur/$id/$electionId/$electeurId');
      print(a.statusCode);
    if(a.statusCode >=200 && a.statusCode < 300){
      print('le corp de: ${a.body}');
      var r = jsonDecode(a.body);
      return r == true;
    }
    return false;
  }
}
