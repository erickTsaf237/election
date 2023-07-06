import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../backend/election.dart';
import '../backend/organisation.dart';
import '../election/election.dart';
import '../main.dart';
import 'package:http/http.dart' as http;


class Accueille extends StatelessWidget {
  Accueille({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyAccueille();
  }
}

class MyAccueille extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAccueille();
  }
}

class _MyAccueille extends State<MyAccueille> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getOrg();
    return Container(
      alignment: Alignment.center,
      child: MyHomePage.currentUser.organisation == null
          ? const Text(
              'Creer une organisation en cliquant sur Plus en bas a droite')
          : FutureBuilder(
              future: ElectionDTO.getAll(),
              builder: (context, AsyncSnapshot<http.Response> response) {
                // print(response);
                if (response.hasError) {
                  return const Text('Il y\'a eu une erreur');
                } else if (response.hasData) {
                  String? a = response.data?.body;
                  String b = a!;
                  dynamic r = jsonDecode(b);
                  int taille = r.length;
                  return ListView(children: [
                    for(int i = 0; i < taille; i++)
                      Election(ElectionDTO.http(r[i])),
                  ]);
                }
                return  Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: const Text(
                    'Shimmer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                );
              }),
    );
  }

  @override
  void initState() {
    super.initState();
    BackendConfig.etat = this;
    Election.etat = this;
  }
}

getOrg() async {
  if(MyHomePage.who == 'employe') {
    return;
  }
  var v = await OrganisationDTO.getOrganisation(MyHomePage.currentUser.id!);
  if (v.statusCode >= 200 && v.statusCode < 300) {
    try {
      var e = json
          .decode(v.body); //nom, code, image, description, createdAt, updatedAt
      MyHomePage.currentUser.organisation = OrganisationDTO.http(
          e['_id'],
          e['nom'],
          e['code'],
          e['image'],
          e['description'],
          DateTime.now(),
          DateTime.now());
      // MyHomePage.currentUser.organisation = OrganisationDTO.http(e['_id'],e['nom'],e['code'],e['image'],e['description'],DateTime.parse(e['createdAt']),DateTime.parse(e['createdAt']) );
    } catch (e) {
      print(e);
      MyHomePage.currentUser.organisation = null;
    }
  }
}
