
import 'package:election/backend/employe.dart';
import 'package:election/section/section.dart';
import 'package:flutter/material.dart';

import '../backend/config.dart';


class CreateEmploye extends StatelessWidget {
  late EmployeDTO? section;

  CreateEmploye({Key? key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateEmploye(
      section: section,
    );
  }
}

class MyCreateEmploye extends StatefulWidget {
  MyCreateEmploye({Key? key, this.section}) : super(key: key);
  late EmployeDTO? section;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateEmploye(user: section);
  }
}

class _MyCreateEmploye extends State<MyCreateEmploye> {
  late EmployeDTO? user;
  var loginController = TextEditingController();
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var numeroController = TextEditingController();
  var confirmerController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _MyCreateEmploye({this.user}) {
    user ??= EmployeDTO('', '', '', '', '', '', id_section: BackendConfig.curenSection!.id!);
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
                "Nouvel Employe",
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
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            // height: 400,
            decoration:
                BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
            // color: Color(0x424242),
            width: 450,
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 16.0,
                      width: 100,
                    ),
                    TextFormField(
                      controller: nomController,
                      // initialValue: depence.id!= null? "${depence.libele}":"",
                      decoration: const InputDecoration(labelText: 'Nom'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre nom ';
                        }
                        return null;
                      },

                      onSaved: (value) => user?.nom = value!,
                    ),
                    TextFormField(
                      controller: prenomController,
                      // initialValue: depence.id!= null? "${depence.libele}":"",
                      decoration: const InputDecoration(labelText: 'Prenom'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre Prenom';
                        }
                        return null;
                      },

                      onSaved: (value) => user?.prenom = value!,
                    ),/*
                    TextFormField(
                      controller: loginController,
                      // initialValue: depence.id!= null? "${depence.libele}":"",
                      decoration: const InputDecoration(labelText: 'Login'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre Login';
                        }
                        return null;
                      },

                      onSaved: (value) => user?.login = value!,
                    ),
                    TextFormField(
                      controller: numeroController,
                      // initialValue: depence.id!= null? "${depence.libele}":"",
                      decoration: const InputDecoration(labelText: 'Numero'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre numero';
                        }
                        return null;
                      },

                      onSaved: (value) => user?.numero = value!,
                    ),*/
                    // const SizedBox(
                    //   height: 16.0,
                    //   width: 100,
                    // ),
                    TextFormField(
                      obscureText: true,

                      decoration: const InputDecoration(labelText: 'Password'),
                      // keyboardType: TextInputType.number,
                      // initialValue: depence.id!= null? "${depence.price}":"",
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                      onSaved: (value) => user?.password = value!,
                    )/*,
                    TextFormField(
                      obscureText: true,

                      decoration: const InputDecoration(labelText: 'Confirmer'),
                      // keyboardType: TextInputType.number,
                      // initialValue: depence.id!= null? "${depence.price}":"",
                      controller: confirmerController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        } else if (passwordController.text !=
                            confirmerController.text) {
                          return "Le mot de passe et la confirmation sont differents";
                        }
                        return null;
                      },
                      onSaved: (value) => user?.confirmer = value!,
                    )*/,
                    const SizedBox(
                      height: 16.0,
                      width: 25,
                    ),
                    // const Expanded(child: Text("J'accepte les termes et conditions")),

                    Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 10),
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
                        style: ButtonStyle(),
                        child: Text('Valider'),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(user?.toJson());
      var loged = await user!.save('employe', token: BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Section.etat?.setState(() {});
      }
    }
    return 0;
  }
}
