

import 'package:election/backend/election.dart';
import 'package:flutter/material.dart';

import '../backend/candidat.dart';
import '../backend/config.dart';

class CreateCandidat extends StatelessWidget {
  late CandidatDTO? candidat;

  CreateCandidat({Key? key, this.candidat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateCandidat(candidat: candidat);
  }
}

class MyCreateCandidat extends StatefulWidget {
  MyCreateCandidat({Key? key, this.candidat}) : super(key: key);
  late CandidatDTO? candidat;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateElection(candidat: candidat);
  }
}

class _MyCreateElection extends State<MyCreateCandidat> {
  late CandidatDTO? candidat;
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var partiController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateElection({this.candidat}) {
    candidat ??=CandidatDTO(nom: '', prenom: '', parti: '');
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
              "Nouvelle Election",
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
                        return 'Veuillez entrer votre nom ';
                      }
                      return null;
                    },

                    onSaved: (value) => candidat?.nom = value!,
                  ),
                  TextFormField(
                    controller: prenomController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Prenom'),
                    maxLength: 64,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre prenom ';
                      }
                      return null;
                    },

                    onSaved: (value) => candidat?.prenom = value!,
                  ),
                  TextFormField(
                    controller: partiController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Parti politique'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le nom du parti';
                      }
                      return null;
                    },

                    onSaved: (value) => candidat?.parti = value!,
                  ),
                 /* TextFormField(
                    controller: valeurController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'valeur'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la valeur du vote';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.valeur = int.parse(value!),
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

                    onSaved: (value) => election?.description = value!,
                  ),*/
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
      print(candidat?.toJson());
      var loged = await candidat!.save('candidat', token:BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        BackendConfig.etat?.setState(() {
        });
      }
    }
    return 0;
  }
}
