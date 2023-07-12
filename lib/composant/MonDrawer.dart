import 'package:election/backend/electeur_dto.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';

import '../electeur/validerElecteur.dart';

class MonDrawer extends StatelessWidget {
  const MonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                '${MyHomePage.currentUser.prenom} ${MyHomePage.currentUser
                    .nom}'),
            accountEmail: SelectableText(MyHomePage.currentUser.login),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                '${MyHomePage.currentUser.prenom.substring(0, 1)
                    .toUpperCase()}${MyHomePage.currentUser.nom.substring(0, 1)
                    .toUpperCase()}',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.man),
            title: Text("Election"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },

          ),
          ListTile(
            leading: Icon(Icons.safety_divider),
            title: Text("Sections"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/section');
            },
            enabled: MyHomePage.currentUser.organisation == null ? false : true,
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Parametres"),
            onTap: () {
              ElecteurDTO electeur = ElecteurDTO('', '', '', '', prenom: 'Erick',
                nom: 'Nteudem',
                date_naissance: DateTime.now().toString(),
                numero_de_cni: '101156204',
                email: 'ericknteudem@gmail.com',
                photo_cni_arriere: "1688942787436-785175029.png",
                photo_cni_avant: '1688942787514-715566054.jpg',
                photo_electeur: '1688942787914-850630123.png',
              );
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AfficherDemandeElecteur(electeur)));
            },
            enabled: MyHomePage.currentUser.organisation == null ? false : true,
          ), ListTile(
            leading: Icon(Icons.store),
            title: Text("Parametres"),
            onTap: () {
              Navigator.pop(context);
            },
            enabled: MyHomePage.currentUser.organisation == null ? false : true,
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text("About Us"),
            onTap: () {
              Navigator.pop(context);
            },
            enabled: MyHomePage.currentUser.organisation == null ? false : true,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Se deconnecter"),
            onTap: () {
              // Navigator.pop(context);

              Navigator.pushReplacementNamed(context, '/choice');
              // Navigator.of(context).pushReplacementNamed('/choice');
            },
          ),
        ],
      ),
    );
  }
}
