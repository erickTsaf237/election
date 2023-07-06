
import 'package:election/backend/config.dart';
import 'package:http/http.dart' as http;

class PetitTest{
  late String nom;
  late String prenom;
  late String cni;

  PetitTest(this.nom, this.prenom, this.cni);

  PetitTest.fromMap(Map<String, String> map){
    nom = map['nom']!;
    prenom = map['prenom']!;
    cni = map['cni']!;
  }
}

class ElecteurDTO extends BackendConfig {
  late String? id;
  late String id_section;
  late String nom;
  late String id_election;
  late String id_bureau;
  late String id_employe;
  late String prenom;
  late String image;
  late String cni;
  late String login;
  late String numero;
  late String confirmer;
  late String password;
  late String date_naissance;
  late String registration_number;

  static const List<String> elcteurField2 = ['nom','prenom','cni'];
  static const List<String> elcteurField = [



    'id_election',
    'id_employe',
    'id_bureau',
    'id_section',
    'nom',
    'prenom',
    'confirmer',
    'login',
    'password',
    'image',
    'cni',
    'registration_number',
    'numero',
    'date_naissance'
  ];

  ElecteurDTO(
      this.id_section, this.id_election, this.id_bureau, this.id_employe,
      {this.nom = '',
      this.prenom = '',
      this.image = '',
      this.cni = '',
      this.login = '',
      this.numero = '',
      this.registration_number = '',
      this.confirmer = '',
      this.password = '',
      this.date_naissance = ''});

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
      'id_election': id_election,
      'id_employe': id_employe,
      'id_bureau': id_bureau,
      'id_section': id_section,
      'nom': nom,
      'prenom': prenom,
      'confirmer': confirmer,
      'login': login,
      'password': password,
      'image': image,
      'cni': cni,
      'registration_number': registration_number,
      'date_naissance': date_naissance
    };
  }

  @override
  Map<String, dynamic> toJson2() {
    return {
      'id': id,
      'id_election': id_election,
      'id_employe': id_employe,
      'id_bureau': id_bureau,
      'id_section': id_section,
      'nom': nom,
      'prenom': prenom,
      'confirmer': confirmer,
      'login': login,
      'password': password,
      'image': image,
      'cni': cni,
      'registration_number': registration_number,
      'date_naissance': date_naissance
    };
  }
  static ElecteurDTO toElecteur(Map<String, dynamic> re) {
    var emp = ElecteurDTO.new(
        re['id_section'],
        re['id_election'],
        re['id_bureau'],
        re['id_employe'],
        cni: re['cni'],
        login: re['login'],
        date_naissance: re['date_naissance'],
        image: re['image'],
        nom: re['nom'],
        prenom: re['prenom'],
        registration_number: re['registration_number'],
        password: re['password'],
        confirmer: re['confirmer'],
        numero: re['numero']);


    return emp;
  }

  @override
  String toString() {
    return 'ElecteurDTO{id: $id, id_section: $id_section,'
        ' nom: $nom, id_election: $id_election,'
        ' id_bureau: $id_bureau, id_employe: $id_employe,'
        ' prenom: $prenom, image: $image, cni: $cni, login: $login,'
        ' numero: $numero, confirmer: $confirmer, password: $password,'
        ' date_naissance: $date_naissance}';
  }

  Future<http.Response> delete() async {
    // await BackendConfig.delete('candidat/election', id!);
    return await BackendConfig.delete('employe', id!);
  }

  static getAll() {
    return BackendConfig.getAll(
        'electeur/section', BackendConfig.curenSection!.id!);
  }

  static isFree() {
    // BureauDTO.
    return BackendConfig.getAll(
        'employe/section', BackendConfig.curenSection!.id!);
  }

  static getOne(id, {autre = ''}) async {
    http.Response res;
    if (autre != '') {
      res = await BackendConfig.getOne('electeur', '$id/$autre');
    } else {
      res = await BackendConfig.getOne('electeur', id);
    }
    return res;
  }
}
