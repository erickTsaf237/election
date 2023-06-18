import 'dart:convert';
import 'dart:developer';

import 'package:election/backend/config.dart';
import 'package:election/backend/user.dart';
import 'package:election/employe/logup_employe.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyLogin();
  }
}

class MyLogin extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyLogin();
  }
}

class _MyLogin extends State<MyLogin> {

  var loginController = TextEditingController(text: 'gobinanelson@gmail.com');
  var passwordController = TextEditingController(text: '123456789');
  var confirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var _valid = false;
  var confirm = false;
  var _text_color = Colors.blue;

  var login = "";
  var password = "";
  var code = "";


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
            child: !confirm
                ? Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Center(
                          child: Title(
                              color: Colors.white,
                              child: const Text(
                                "Se Connecter",
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
                          controller: loginController,
                          // initialValue: depence.id!= null? "${depence.libele}":"",
                          decoration: const InputDecoration(labelText: 'Login'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your login';
                            }
                            return null;
                          },

                          onSaved: (value) => login = value!,
                        ),
                        const SizedBox(
                          height: 16.0,
                          width: 100,
                        ),
                        TextFormField(
                          obscureText: true,

                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          keyboardType: TextInputType.number,
                          // initialValue: depence.id!= null? "${depence.price}":"",
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!,
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
                                child:
                                    Text("J'accepte les termes et conditions")),
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
                            style: ButtonStyle(),
                            child: Text('Valider'),
                          ),
                        ),
                        InkWell(
                          child: Text("Creer un compte",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: _text_color)),
                          onTap: () {
                            if(MyHomePage.who == 'employe') {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LogupEmplye()));
                            }else {
                              Navigator.pushReplacementNamed(context, '/logup');
                            }
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Logup()));
                          },
                        )
                      ],
                    ))
                : Form(
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
                          child: const Text('Nous vous avons envoyer un code de confirmation sur vodre adresse email, veiller la confirmer', style: TextStyle(fontSize: 17,)),),
                        const SizedBox(
                          height: 16.0,
                          width: 100,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,

                          controller: confirmationController,
                          // initialValue: depence.id!= null? "${depence.libele}":"",
                          decoration: const InputDecoration(labelText: 'code de confirmation', border: OutlineInputBorder( borderRadius: BorderRadius.zero, borderSide: BorderSide(color: Colors.black, width: 2))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer le code de confirmation';
                            }
                            return null;
                          },

                          onSaved: (value) => code = value!,
                        ),
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
                  )),
      ),
    );
  }

  Future<int> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      login = loginController.text;
      password = passwordController.text;
      _formKey.currentState!.save();
      var loged = await UserBackend.log_in(login, password, identite: MyHomePage.who);
      if (loged) {
        // return 1;
        // confirm=true;
        setState(() {
          confirm = true;
          print('${BackendConfig.token}     ooooooooooooooooooooooo');
          confirmationController = TextEditingController(text: BackendConfig.token);
        });
        // Navigator.pushReplacementNamed(context, '/home');
      }
      return -1;
      // log(re);
      // Navigator.pop(context);
    }
    return 0;
  }
  Future<int> _confirm(BuildContext context) async {
    if (_formKey2.currentState!.validate()) {
      var token = confirmationController.text;
      _formKey2.currentState!.save();
      var loged = await UserBackend.confirmToken(login, password, token, identite: MyHomePage.who);
      if (loged) {
        Navigator.pushReplacementNamed(context, '/home');
      }
      return -1;
    }
    return 0;
  }
}
