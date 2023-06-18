import 'dart:convert';

import 'package:election/backend/bureau_dto.dart';
import 'package:election/backend/employe.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../backend/config.dart';
import 'bureau.dart';

class CreateBureau extends StatelessWidget {
  late BureauDTO? bureau;

  CreateBureau({Key? key, this.bureau}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateBureau(
      bureau: bureau,
    );
  }
}

class MyCreateBureau extends StatefulWidget {
  MyCreateBureau({Key? key, this.bureau}) : super(key: key);
  late BureauDTO? bureau;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateBureau(bureau: bureau);
  }
}

class _MyCreateBureau extends State<MyCreateBureau> {
  late BureauDTO? bureau;
  var nomController = TextEditingController();
  var villeController =
      TextEditingController(text: BackendConfig.curenSection!.ville);
  var passwordController = TextEditingController();
  var categorieController = TextEditingController();
  var localisationController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateBureau({this.bureau}) {
    bureau ??= BureauDTO(
        BackendConfig.curenSection!.id_responsable!,
        BackendConfig.curenSection!.id!,
        '',
        '',
        '',
        '',
        MyHomePage.currentUser.id!);
  }

  var option = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  var dropDownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Title(
            color: Colors.white,
            child: const Text(
              "Nouveau bureau",
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

                    onSaved: (value) => bureau?.nom = value!,
                  ),
                  TextFormField(
                    controller: villeController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Ville'),
                    maxLength: 32,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la ville';
                      }
                      return null;
                    },

                    onSaved: (value) => bureau?.ville = value!,
                  ),
                  TextFormField(
                    controller: categorieController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'password'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la la password';
                      }
                      return null;
                    },
                    onSaved: (value) => bureau?.password = value!,
                  ),
                  TextFormField(
                    controller: localisationController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration:
                        const InputDecoration(labelText: 'Localisation'),
                    maxLength: 32,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la localisation';
                      }
                      return null;
                    },
                    onSaved: (value) => bureau?.localisation = value!,
                  ),
                  FutureBuilder(
                      future: EmployeDTO.getAllFree(),
                      builder:
                          (context, AsyncSnapshot<List<EmployeDTO>> response2) {
                        if (response2.data != []) {
                          List<EmployeDTO>? response = response2.data;
                          return DropdownButtonFormField(
                            items: response?.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                value: e.id,
                                child: Text('${e.nom} ${e.prenom}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropDownValue = value.toString();
                                bureau?.id_responsable = value.toString();
                              });
                            },
                            decoration: const InputDecoration(
                                labelText: 'responsable du bureau'),
                          );
                        }

                        return const Text('Aucun employe de disponible');
                      }),
                  TextFormField(
                    controller: descController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(
                        hintText: 'Decrivez ce bureau',
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

                    onSaved: (value) => bureau?.description = value!,
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
      // print(bureau?.toJson());
      var loged = await bureau!.save('bureau', token: BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        BackendConfig.etat?.setState(() {});
      }
    }
    return 0;
  }
}
