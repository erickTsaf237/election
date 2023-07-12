
import 'package:election/backend/electeur_dto.dart';
import 'package:election/bureau/bureau.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/config.dart';

class MyCreateElecteur extends StatefulWidget{
  late ElecteurDTO electeur;

  MyCreateElecteur(this.electeur, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateElecteur(electeur);
  }

}

class _MyCreateElecteur extends State<MyCreateElecteur>{
  late ElecteurDTO electeur;
  _MyCreateElecteur(this.electeur) ;


  final _formkey = GlobalKey<FormState>();
  var CNIController = TextEditingController();
  var nomController = TextEditingController();
  var prenomController = TextEditingController();
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  var numeroController = TextEditingController();
  var dateNaissanceController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('nouvel electeur'),),
      body: Container(child: Form(
        key: _formkey, child: ListView(children: [
        TextFormField(
          controller: CNIController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'CNI numeber'),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly // ne permet que la saisie de chiffres
          ],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your id Cart number';
            }
            return null;
          },

          onSaved: (value) => electeur.numero_de_cni = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: nomController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'nom'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },

          onSaved: (value) => electeur.nom = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: prenomController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'Prenom'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your prenom';
            }
            return null;
          },

          onSaved: (value) => electeur.prenom = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: loginController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'Login'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your login';
            }
            return null;
          },

          onSaved: (value) => electeur.email = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: numeroController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'Numero'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your number';
            }
            return null;
          },

          onSaved: (value) => electeur.numero = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: passwordController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'password'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },

          onSaved: (value) => electeur.password = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
        ),TextFormField(
          controller: confirmController,
          // initialValue: depence.id!= null? "${depence.libele}":"",
          decoration: const InputDecoration(labelText: 'Confirmation'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please confirm your password';
            }
            else if (value.isNotEmpty && passwordController.text != value) {
              print('${passwordController.text} != $value');
              return 'the password and his confirmation are not the same';
            }
            return null;
          },

          onSaved: (value) => electeur.confirmer = value!,
        ),
        const SizedBox(
          height: 16.0,
          width: 100,
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
      ],),
      ),)

    );
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      print(electeur.toJson());
      var loged = await electeur.save('electeur', token: BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Bureau.etat?.setState(() {});
      }
    }
    return 0;
  }

}