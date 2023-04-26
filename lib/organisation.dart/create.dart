import 'dart:convert';

import 'package:election/backend/organisation.dart';
import 'package:election/backend/user.dart';
import 'package:flutter/material.dart';

import '../backend/config.dart';

class CreateOrganisation extends StatelessWidget {
  late OrganisationDTO? organisation;

  CreateOrganisation({Key? key, this.organisation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateOrganisation();
  }
}

class MyCreateOrganisation extends StatefulWidget {
  MyCreateOrganisation({Key? key, this.organisation}) : super(key: key);
  late OrganisationDTO? organisation;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateOrganisation(organisation: organisation);
  }
}

class _MyCreateOrganisation extends State<MyCreateOrganisation> {
  late OrganisationDTO? organisation;
  var loginController = TextEditingController();
  var nomController = TextEditingController();
  var codeController = TextEditingController();
  var descController = TextEditingController();
  var confirmerController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateOrganisation({this.organisation}) {
    organisation ??= OrganisationDTO('', code: '');
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
              "Nouvelle organsation",
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
              child: Column(
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

                    onSaved: (value) => organisation?.nom = value!,
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

                    onSaved: (value) => organisation?.code = value!,
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

                    onSaved: (value) => organisation?.description = value!,
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
      print(organisation?.toJson());
      var loged = await organisation!.save('organisation', token:BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
      }
    }
    return 0;
  }
}
