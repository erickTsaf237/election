import 'package:election/main.dart';
import 'package:flutter/material.dart';

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
            accountName: Text('${MyHomePage.currentUser.prenom} ${MyHomePage.currentUser.nom}'),
            accountEmail: Text(MyHomePage.currentUser.login),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                '${MyHomePage.currentUser.prenom.substring(0,1).toUpperCase()}${MyHomePage.currentUser.nom.substring(0,1).toUpperCase()}',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.man),
            title: Text("Election"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("Compte"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Parametres"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text("About Us"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Se deconnecter"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
