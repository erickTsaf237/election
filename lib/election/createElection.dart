
import 'dart:convert';

import 'package:election/backend/election.dart';
import 'package:election/backend/organisation.dart';
import 'package:election/backend/user.dart';
import 'package:election/election/election.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';

import '../backend/config.dart';

class CreateElection extends StatelessWidget {
  late ElectionDTO? election;

  CreateElection({Key? key, this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateElection(election: election,);
  }
}

class MyCreateElection extends StatefulWidget {
  MyCreateElection({Key? key, this.election}) : super(key: key);
  late ElectionDTO? election;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateElection(election: election);
  }
}

class _MyCreateElection extends State<MyCreateElection> {
  late ElectionDTO? election;
  var loginController = TextEditingController();
  var libeleController = TextEditingController();
  var codeController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateElection({this.election}) {
    election ??= ElectionDTO('', '', DateTime.now(), 1);
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
                    controller: libeleController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Libele'),
                    maxLength: 64,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre libele ';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.libele = value!,
                  ),
                  TextFormField(
                    controller: codeController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Code'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le code';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.code = value!,
                  ),
                  TextFormField(
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
      print(election?.toJson());
      var loged = await election!.save('election', token:BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Election.etat?.setState(() {});
      }
    }
    return 0;
  }
}
