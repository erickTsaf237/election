import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/composant/accueille.dart';
import 'package:election/main.dart';
import 'package:http/http.dart' as http;

import 'employe.dart';

class UserBackend extends BackendConfig {
  late String? id;
  late String nom;
  late String prenom;
  late String login;
  late String numero;
  late String confirmer;
  late String password;
  late OrganisationDTO? organisation;

  UserBackend({
    required this.nom,
    required this.prenom,
    required this.login,
    required this.numero,
    required this.confirmer,
    required this.password,
    this.id = '',
  }) {
    print(this);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'login': login,
      'numero': numero,
      'confirmer': confirmer,
      'password': password
    };
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
      'password': password
    };
  }

  static UserBackend toUser(Map<String, dynamic> re) {
    return UserBackend(
        nom: re['nom'],
        prenom: re['prenom'],
        login: re['login'],
        numero: re['numero'],
        confirmer: '',
        password: re['password'],
        id: re['_id']);
  }

  static Future<bool> isloged(http.Response response,
      {token = '', identite = 'admin'}) async {
    print(response.body);
    bool retour = false;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // BackendConfig.token = jsonDecode(response.body)['code'];
      if (token != '') {
        var token = jsonDecode(response.body);
        if (identite == 'admin') {
          MyHomePage.currentUser = toUser(token['user']);
        } else {
          MyHomePage.currentEMploye = EmployeDTO.toEmploye(token['user'], add: false);
          BackendConfig.token = token['access_token'];
          return await EmployeDTO.createCurentOrganisationAndUser(MyHomePage.currentEMploye );
        }
        await getOrg();
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

  Future<bool> logup() async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/user"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(toJson()));
    // return await logUserIn(res);
    print(res.body);
    return true;
    return await logUserIn(res);
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

  static Future<bool> log_in(login, password, {identite = 'admin'}) async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/auth"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'identite': identite
        }));
    return await isloged(res, identite: identite);
  }

  static Future<bool> confirmToken(login, password, token, {identite = 'admin'}) async {
    print(login + ' ' + password + ' ' + token);
    final res = await http.post(
        Uri.parse("${BackendConfig.host}/auth/activate"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'token': token,
          'identite': identite
        }));
    return isloged(res, token: token, identite: identite);
  }
}
