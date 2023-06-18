import 'dart:convert';

import 'package:election/backend/employe.dart';
import 'package:election/backend/user.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LogupEmplye extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyLogupEmplye();
  }
}

class MyLogupEmplye extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyLogupEmplye();
  }
}

class _MyLogupEmplye extends State<MyLogupEmplye> {

  var loginController = TextEditingController(text: 'ericktsafack2017@gmail.com');
  var passwordController = TextEditingController(text: '123456789');
  var confirmationController = TextEditingController();
  var numeroController = TextEditingController();
  var idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  var _valid = false;
  var _erreur = false;
  var confirm = false;
  var _niveau = 1;
  var _text_color = Colors.blue;

  var login = "";
  var id = "";
  var nom = "";
  var prenom = "";
  var password = "";
  var numero = "";


  // @override
  // void initState() {
  //   super.initState();
  //
  //   loginController.text('ericktsafack2017@gmail.com');
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            height: 400,
            decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
            // color: Color(0x424242),
            width: 450,
            child: _niveau==1
                ? Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Title(
                          color: Colors.white,
                          child: const Text(
                            "Retrouvez votre Compte",
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
                      controller: idController,
                      // initialValue: depence.id!= null? "${depence.libele}":"",
                      decoration: const InputDecoration(labelText: 'Identifiant Unique'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre identifiant';
                        }
                        return null;
                      },

                      onSaved: (value) => id = value!,
                    ),if(_erreur)
                      Text('Cet identifiant n\'existe pas'),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          var loged = await _submit(context);
                          if (loged == 1) {
                            // Navigator.pushReplacementNamed(context, 'routeName');
                          } else if (loged == 0) {
                            // Navigator.pushReplacementNamed(context, 'routeName');
                            setState((){
                              _erreur = true;
                            });
                            print('echec de conn');
                          } else {
                            // Navigator.pushReplacementNamed(context, 'routeName');
                          }
                        },
                        style: ButtonStyle(),
                        child: Text('Valider'),
                      ),
                    )
                  ],
                ))
                :_niveau==2? Form(
              key: _formKey2,
              child: ListView(
                children: [
                  Center(
                    child: Title(
                        color: Colors.white,
                        child: const Text(
                          "Authentifiez vous",
                          style: TextStyle(
                              fontSize: 35,
                              decoration: TextDecoration.underline,
                              color: Colors.indigo),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text('Les donnee suivantes ont ete retrouve pour l\'identifiant que vous avez fourni. S\'il s\'agit bien de vous veuiller le confirmer avec le mot de passe de cet employe', style: TextStyle(fontSize: 17,)),),
                  const SizedBox(
                    height: 16.0,
                    width: 100,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Text('Nom: $nom', style: TextStyle(fontSize: 17,)),),
                  const SizedBox(
                    height: 16.0,
                    width: 100,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Text('Penom: $prenom', style: TextStyle(fontSize: 17,)),),
                  const SizedBox(
                    height: 16.0,
                    width: 100,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,

                    controller: passwordController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'mot de passe', border: OutlineInputBorder( borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.black, width: 2))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },

                    onSaved: (value) => password = value!,
                  ),if(_erreur)
                    Text('Cet Mot de passe incorecte'),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var loged = await _confirm(context);
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
              ),
            ):_niveau==3? Form(
            key: _formKey3,
          child: ListView(
            children: [
              Center(
                child: Title(
                    color: Colors.white,
                    child: const Text(
                      "Completez vos informations a fin de vous connecter",
                      style: TextStyle(
                          fontSize: 35,
                          decoration: TextDecoration.underline,
                          color: Colors.indigo),
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: const Text('', style: TextStyle(fontSize: 17,)),),
              const SizedBox(
                height: 16.0,
                width: 100,
              ),
            TextFormField(
              controller: loginController,
              // initialValue: depence.id!= null? "${depence.libele}":"",
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Email';
                }
                return null;
              },

              onSaved: (value) => login = value!,
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

              onSaved: (value) => numero = value!,
            ),
              Container(
                width: 100,
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    var loged = await _complete(context);
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
          ),
        ):Text('Felicitation')),
      ),
    );
  }

  Future<int> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      id = loginController.text;
      password = passwordController.text;
      _formKey.currentState!.save();
      http.Response res = await EmployeDTO.getOne(id);
      if(res.statusCode >=200 && res.statusCode<300){
        var a = jsonDecode(res.body);
        if(a['_id'] == id) {
          setState(() {
            nom = a['nom'];
            prenom = a['prenom'];
            login = a['login'];
            loginController.text = login;
            confirm = true;
            _niveau = 2;
            _erreur = false;
          });
          return 1;
        }
      }
      else{
        setState(() {
          _erreur = true;
        });
      }
      return -1;
    }
    return 0;
  }
  Future<int> _confirm(BuildContext context) async {
    if (_formKey2.currentState!.validate()) {
      _formKey2.currentState!.save();

      var loged = await EmployeDTO.getOne(id, autre: password);
      setState(() {
        confirm = true;
        _niveau = 3;
      });
      return -1;
    }
    return 0;
  }

  Future<int> _complete(BuildContext context) async {
    if (_formKey3.currentState!.validate()) {
      var token = confirmationController.text;
      _formKey3.currentState!.save();
      var loged = await EmployeDTO.logup(id, password, login, numero);
      if (loged) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return -1;
    }
    return 0;
  }
}
