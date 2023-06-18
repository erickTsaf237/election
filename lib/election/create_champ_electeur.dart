

import 'package:election/backend/election.dart';
import 'package:election/election/election.dart';
import 'package:flutter/material.dart';

import '../backend/candidat.dart';
import '../backend/config.dart';

class Create_champ_Electeur extends StatelessWidget {
  late ElectionDTO? candidat;

  Create_champ_Electeur({Key? key, this.candidat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreate_champ_Electeur(candidat: candidat);
  }
}

class MyCreate_champ_Electeur extends StatefulWidget {
  MyCreate_champ_Electeur({Key? key, this.candidat}) : super(key: key);
  late ElectionDTO? candidat;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreate_champ_Electeur(candidat: candidat);
  }
}

class _MyCreate_champ_Electeur extends State<MyCreate_champ_Electeur> {
  late ElectionDTO? candidat;
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var partiController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  late List<TextEditingController> controllers = [];
  late List<bool> unique = [];
  final _formKey = GlobalKey<FormState>();

  _MyCreate_champ_Electeur({this.candidat}) {
    candidat ??=ElectionDTO('libele', 'code', DateTime.now(), 1);
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    print(candidat!.champElecteur);
    controllers = candidat!.champElecteur.map((e){
      print('object');
      var a = TextEditingController(text: e[0]);
      unique.add(e[1]== 'true');
      // if(e.isEmpty) {
      //   a.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
      // }
      return a;
    }).toList();
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Title(
            color: Colors.white,
            child: const Text(
              "Liste des Champs pour les electeurs",
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
                  for(var index = 0; index < candidat!.champElecteur.length; index++)
                    Row(
                      children: [
                        Expanded(child: TextFormField(
                          controller: controllers[index],
                          maxLength: 64,
                          validator: (value) {
                            if (value!.isEmpty) {
                              print('${candidat!.champElecteur.length}  ===================');
                              setState((){
                                candidat?.champElecteur.removeAt(index);
                              });
                              return '';
                            }
                            return null;
                          },
                          onChanged: (value){
                            if (value.isEmpty && candidat!.champElecteur.length > 1) {
                              setState(() {
                                candidat?.champElecteur.removeAt(index);
                              });
                            }else {
                              candidat?.champElecteur[index][0] = value;
                            }
                            print(index);
                          },
                          onEditingComplete: (){
                            print('object');
                            if(candidat!.champElecteur[index][0].isNotEmpty){
                              setState(() {
                                candidat?.champElecteur.add(['', 'false']);
                                _formKey.currentState!.save();
                              });
                            }
                          },
                          autofocus: index == (candidat!.champElecteur.length-1)?true:false,
                          onSaved: (value) => candidat?.champElecteur[index][0] = value!,
                          enableSuggestions: true,
                        )),
                        Container(
                          child: Row(
                            children: [
                              Checkbox(
                                  value: candidat?.champElecteur[index][1]=='true',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      candidat?.champElecteur[index][1] = '${value!}';
                                    });
                                  }),
                              Text('Unique'),
                            ],
                          ),
                        )
                      ]

                      ,
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
      // print(candidat?.toJson());
      // return 1;
      var loged = await candidat!.update('election/liste', token:BackendConfig.token);
      if (loged) {

        Navigator.pop(context);
        BackendConfig.etat?.setState(() {
        });
      }
    }
    return 0;
  }
}
