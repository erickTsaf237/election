import 'dart:convert';

import 'package:election/backend/user.dart';
import 'package:flutter/material.dart';

class Logup extends StatelessWidget {
  const Logup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MyLogup();
  }
}

class MyLogup extends StatefulWidget {
  const MyLogup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyLogup();
  }
}

class _MyLogup extends State<MyLogup> {
  var loginController = TextEditingController();
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var numeroController = TextEditingController();
  var confirmerController = TextEditingController();
  var passwordController = TextEditingController();
   late UserBackend? user ;
  final _formKey = GlobalKey<FormState>();
  var _valid = false;
  var _text_color = Colors.blue;


  _MyLogup({this.user=null}){
    user = UserBackend(
          nom: 'nom',
          prenom: 'prenom',
          login: 'login',
          numero: 'numero',
          confirmer: 'confirmer',
          password: 'confirmer');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Container(
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
                    Center(
                      child: Title(
                          color: Colors.white,
                          child: const Text(
                            "Creer un Compte",
                            style: TextStyle(
                                fontSize: 35,
                                decoration: TextDecoration.underline,
                                color: Colors.indigo),
                          )),
                    ),
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
                    ),
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
                    ),
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
                    ),
                    TextFormField(
                      obscureText: true,

                      decoration: const InputDecoration(labelText: 'Confirmer'),
                      // keyboardType: TextInputType.number,
                      // initialValue: depence.id!= null? "${depence.price}":"",
                      controller: confirmerController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        else if(passwordController.text != confirmerController.text){
                          return "Le mot de passe et la confirmation sont differents";
                        }
                        return null;
                      },
                      onSaved: (value) => user?.confirmer = value!,
                    ),
                    const SizedBox(
                      height: 16.0,
                      width: 25,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: _valid,
                            onChanged: (bool? value) {
                              setState(() {
                                _valid = value!;
                              });
                            }),
                        const Expanded(
                            child: Text("J'accepte les termes et conditions")),
                        InkWell(
                          onTap: () {
                            print('object');
                          },
                          mouseCursor: SystemMouseCursors.click,
                          onHover: (value) {
                            setState(() {
                              if (value == false) {
                                _text_color = Colors.blue;
                              } else {
                                _text_color = Colors.red;
                              }
                            });
                          },
                          child: Text("Consulter le conditions",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: _text_color)),
                        )
                      ],
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
                    InkWell(
                      child: Text("J'ai deja un compte",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 13,
                              color: _text_color)),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Login()));
                      },
                    )
                  ],
                )),
          )),
    );
  }

  Future<int> _submit(BuildContext context) async {

    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(user?.toJson());
      var loged = await user!.logup();
      if(loged){
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
    return 0;
  }
}
