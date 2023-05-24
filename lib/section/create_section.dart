
import 'dart:convert';

import 'package:election/backend/election.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/backend/user.dart';
import 'package:election/election/election.dart';
import 'package:election/main.dart';
import 'package:election/section/section.dart';
import 'package:flutter/material.dart';

import '../backend/config.dart';
import '../backend/section.dart';

class CreateSection extends StatelessWidget {
  late SectionDTO? section;

  CreateSection({Key? key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateSection(section: section,);
  }
}

class MyCreateSection extends StatefulWidget {
  MyCreateSection({Key? key, this.section}) : super(key: key);
  late SectionDTO? section;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateSection(section: section);
  }
}

class _MyCreateSection extends State<MyCreateSection> {
  late SectionDTO? section;
  var nomController = TextEditingController();
  var villeController = TextEditingController();
  var categorieController = TextEditingController();
  var localisationController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateSection({this.section}) {
    section ??= SectionDTO('','', '', '');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Title(
            color: Colors.white,
            child: const Text(
              "Nouvelle section",
              style: TextStyle(
                  fontSize: 35,
                  decoration: TextDecoration.underline,
                  color: Colors.indigo),
            )),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ],
      content: Container(
          constraints: const BoxConstraints.tightFor(width: 450, height: 400),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          // height: 300,
          decoration:
          BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
          child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: nomController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Nom'),
                    maxLength: 64,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le nom ';
                      }
                      return null;
                    },

                    onSaved: (value) => section?.nom = value!,
                  ),
                  TextFormField(
                    controller: villeController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Ville'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la ville';
                      }
                      return null;
                    },

                    onSaved: (value) => section?.ville = value!,
                  ),
                  TextFormField(
                    controller: categorieController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'categorie'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la la categorie';
                      }
                      return null;
                    },
                    onSaved: (value) => section?.categorie = value!,
                  ),
                  TextFormField(
                    controller: localisationController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Localisation'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la localisation';
                      }
                      return null;
                    },
                    onSaved: (value) => section?.localisation = value!,
                  ),
                  TextFormField(
                    controller: descController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(
                        hintText: 'Decrivez votre organisation',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ))),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 1000,
                    validator: (value) {
                      return null;
                    },

                    onSaved: (value) => section?.description = value!,
                  ),
                  Container(
                    // width: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var loged = await _submit(context);
                        if (loged == 1) {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                        } else if (loged == 0) {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                          print('echec de conn');
                        } else {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                        }
                      },
                      style: const ButtonStyle(),
                      child: const Text('Valider'),
                    ),
                  )
                ],
              ))),
    );
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(section?.toJson());
      var loged = await section!.save('section', token:BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Section.etat?.setState(() {});
      }
    }
    return 0;
  }
}
