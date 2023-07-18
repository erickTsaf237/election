
import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

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
  late String numero_de_cni;
  late String photo_electeur;
  late String photo_cni_avant;
  late String photo_cni_arriere;
  late String email;
  late String valide;
  late String numero;
  late String confirmer;
  late String password;
  late String date_naissance;
  late String registration_number;


  static List<ElecteurDTO> electeurs = [];

  static const List<String> elcteurField2 = ['nom','prenom','cni'];
  static const List<String> elcteurField = [
    'id_election',
    'id_employe',
    'id_bureau',
    'id_section',
    'nom',
    'prenom',
    'confirmer',
    'email',
    'password',
    'image',
    'numero_de_cni',
    'registration_number',
    'numero',
    'date_naissance'
  ];


  ElecteurDTO(
      this.id_section, this.id_election, this.id_bureau, this.id_employe,
      {this.nom = '',
      this.prenom = '',
      this.image = '',
      this.numero_de_cni = '',
      this.email = '',
      this.numero = '',
      this.photo_cni_avant = '',
      this.photo_electeur = '',
      this.photo_cni_arriere = '',
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
      'id_employe': id_employe??'',
      'id_bureau': id_bureau??'',
      'id_section': id_section,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'valide': valide,
      'image': photo_electeur,
      'numero_de_cni': numero_de_cni,
      'date_naissance': date_naissance
    };
  }

  Future<http.Response> repondreDemande() async {
    Map<String,String> map =  {'valide':valide};
    final res = await updateSomme('electeur/reponse', id!, map);
    return res;
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
      'login': email,
      'email': password,
      'image': image,
      'numero_de_cni': numero_de_cni,
      'registration_number': registration_number,
      'date_naissance': date_naissance
    };
  }
  ElecteurDTO.fromDemande(Map<String, dynamic> re) {
    print(re);
    this.id = re['_id'];
    this.id_section = re['id_section'];
    this.id_election = re['id_election'];
    this.numero_de_cni= re['numero_de_cni'];
    this.email= re['email'];
    this.date_naissance=  re['date_naissance'];
    // this. = image: re['image'];
    this.nom= re['nom'];
    this.prenom= re['prenom'];
    this.photo_cni_arriere= re['photo_cni_arriere'];
    this.photo_cni_avant= re['photo_cni_avant'];
    this.photo_electeur= re['photo_electeur'];
    this.numero= re['numero']??'';
    this.id_bureau= re['id_bureau']??'';
    // registration_number: re['registration_number'];
  }

  static const List<String> elcteurFieldValide = [

    'photo_electeur',
    'numero_de_cni',
    'nom',
    'prenom',
    'email',
    'date_naissance'
  ];

  static ElecteurDTO toElecteur(Map<String, dynamic> re) {
    var emp = ElecteurDTO.new(
        re['id_section'],
        re['id_election'],
        re['id_bureau'],
        re['id_employe'],
        numero_de_cni: re['numero_de_cni'],
        email: re['email'],
        date_naissance: re['date_naissance'],
        image: re['image']??'',
        nom: re['nom'],
        prenom: re['prenom'],
        registration_number: re['registration_number']??'',
        password: re['password']??'',
        confirmer: re['confirmer'],
        numero: re['numero']);


    return emp;
  }

  @override
  String toString() {
    return 'ElecteurDTO{id: $id, id_section: $id_section,'
        ' nom: $nom, id_election: $id_election,'
        ' prenom: $prenom, numero_de_cni: $numero_de_cni, email: $email,'
        ' date_naissance: $date_naissance}';
  }

  Future<http.Response> delete() async {
    return await BackendConfig.delete('employe', id!);
  }

  static getAllElecteurBySectionId() {
    if (MyHomePage.who == 'admin') {
      return BackendConfig.getAll(
          'electeur/election', BackendConfig.curenElectifon!.id!);
    }
    return BackendConfig.getAll(
        'electeur/section', BackendConfig.curenSection!.id!);
  }

  static isFree() {
    // BureauDTO.
    return BackendConfig.getAll(
        'employe/section', BackendConfig.curenSection!.id!);
  }

  static Future<ElecteurDTO?> getOne(id, {autre = ''}) async {
    http.Response res;
    print('electeur/election/$id/$autre');
    if (autre != '') {
      res = await BackendConfig.getOne('electeur/election', '$id/$autre');
    } else {
      res = await BackendConfig.getOne('electeur', id);
    }
    if (res.statusCode >= 200 && res.statusCode < 300){
      try{
        return ElecteurDTO.fromDemande(jsonDecode(res.body)!);
      }catch(e){
        print('************************************************************');
        print('la caversion du resultat a echoue');
        print(res.body);
        print('************************************************************');
      }
    }
    return null;
  }

  static getElecteurBureau() {
    return BackendConfig.getAll(
        'electeur/bureau', BackendConfig.curenBureau!.id!);
  }

  static definirCOmmeVotant() {
    return BackendConfig.getAll(
        'electeur/bureau', BackendConfig.curenBureau!.id!);
  }


}
