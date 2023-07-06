import 'dart:convert';
import 'dart:io';

import 'package:election/backend/election.dart';
import 'package:flutter/material.dart';

import '../backend/candidat.dart';
import '../backend/config.dart';
import '../tools/images.dart';

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
  String deleteMessage = '';

  File? _imageFile;

  _MyCreateElection({this.candidat}) {
    candidat ??= CandidatDTO(nom: '', prenom: '', parti: '');
    nomController.text = candidat!.nom;
    prenomController.text = candidat!.prenom;
    partiController.text = candidat!.parti;
    nomController.text = candidat!.nom;
  }

  @override
  Widget build(BuildContext context) {
    print('$_imageFile oooooo');
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Title(
            color: Colors.white,
            child:  Text(
              candidat!.id!.isEmpty?
              "Nouveau candidat":
              'Modifier le candidat',
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
                    decoration:
                        const InputDecoration(labelText: 'Parti politique'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le nom du parti';
                      }
                      return null;
                    },

                    onSaved: (value) => candidat?.parti = value!,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            pickImage(this, _imageFile).then((value) => {
                              if (value != null)
                                {
                                  setState(() {
                                    print(value);
                                    print(_imageFile);
                                    _imageFile = value;
                                    // candidat?.image = null;
                                  })
                                }
                            });
                          },
                          child: Text('Select an image')),
                      if (candidat!.image.isEmpty || _imageFile != null)
                        _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 100,
                                width: 80,
                              )
                            : Icon(
                                Icons.image,
                                color: Colors.blue,
                              ),
                      if (candidat!.image.isNotEmpty && _imageFile == null)
                        Image.network(
                          '${BackendConfig.host}/${candidat!.image}',
                          height: 100,
                          width: 80,
                        ),

                    ],
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
                  ),
                  if(candidat!.id!.isNotEmpty)
                  Container(
                    // width: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var loged = await deleteCandidat();
                        if (loged == true) {
                          Navigator.pop(context);
                          BackendConfig.etat?.setState(() {});
                          // Navigator.pushReplacementNamed(context, 'routeName');
                        }else {
                          setState(() {
                            deleteMessage = 'Echec de suppression';
                          });
                        }
                      },
                      style:  ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text('Supprimer'),
                    ),
                  ),
                  if(deleteMessage.isNotEmpty)
                    Center(child: Text(deleteMessage, style: TextStyle(color: Colors.red),),)
                ],
              ))),
    );
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(candidat?.toJson());
      var re;
      if (candidat!.id!.isNotEmpty) {
        re = await candidat!.update('candidat', token: BackendConfig.token);
        if (_imageFile != null) {
          // print(candidat!.toJson2());
          print(candidat);
          candidat!.uploadFile(_imageFile!, 'candidat', candidat!.id!);
        }
      } else {
        re = await candidat!.save3('candidat', token: BackendConfig.token);
        if (re.statusCode >= 200 && re.statusCode < 300) {
          if (_imageFile != null) {
            var data = jsonDecode(re.body);
            print(re.body);
            var id = data['_id'];
            candidat!.uploadFile(_imageFile!, 'candidat', id);
          }
        }
      }
      Navigator.pop(context);
      BackendConfig.etat?.setState(() {});
    }
    return 0;
  }

  Future<bool> deleteCandidat()async {
    var re = await candidat!.deleteCandidat();
    return re;
  }
}
