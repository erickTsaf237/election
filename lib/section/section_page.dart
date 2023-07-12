import 'dart:convert';

import 'package:election/backend/config.dart';
import 'package:election/backend/employe.dart';
import 'package:election/bureau/bureau_page.dart';
import 'package:election/employe/employe.dart';
import 'package:election/section/create_section.dart';
import 'package:election/section/section.dart';
import 'package:flutter/material.dart';
import '../backend/section.dart';
import '../bureau/create_bureau.dart';
import '../composant/MonDrawer.dart';
import '../employe/create_employe.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class SectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MySectionPage();
  }
}

class MySectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MySectionPage();
  }
}

class _MySectionPage extends State<MySectionPage> {
  void _incrementCounter() {
    BackendConfig.etat = this;
    Section.etat = this;
    setState(() {});
    showDialog(
        context: context,
        builder: (context) {
          return CreateSection();
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // getOrg();
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Section'),
      ),
      drawer: const MonDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: MyHomePage.currentUser.organisation == null
            ? const Text('Creer des section de votre organisation')
            : FutureBuilder(
                future: SectionDTO.getAll(),
                builder: (context, AsyncSnapshot<http.Response> response) {
                  if (response.hasError) {
                    return const Text('Il y\'a eu une erreur');
                  } else if (response.hasData) {
                    String? a = response.data?.body;
                    String b = a!;
                    dynamic r = jsonDecode(b);
                    int taille = r.length;
                    if (taille == 0) {
                      return const Text(
                          'Votre organisation ne contient aucune section');
                    }
                    return ListView(children: [
                      for (int i = 0; i < taille; i++)
                        Section(SectionDTO.http(r[i])),
                    ]);
                  }
                  return Text('Liste vide');
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _incrementCounter();
        },
        tooltip: 'Nouvelle Section',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    BackendConfig.etat = this;
    Section.etat = this;
  }
}

class SectionePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MySectionePage();
  }
}

class MySectionePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MySectionePage();
  }
}

class _MySectionePage extends State<MySectionePage> {
  void _incrementCounter() {
    Section.etat = this;
    setState(() {});
  }
  late int tabIndex = 0;
  late Function flottingButtonActionFunction;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return DefaultTabController(length: 3, child: Scaffold(
       body: TabBarView(children: [
         getListeSectionItem(context),
         getListeBureauItem(context),
         // getListeBureauItem(context)
         getListeDemandeElecteur(context)
       ],),
       drawer: MonDrawer(),
       appBar: AppBar(
         title: const Text('section page'),
         bottom:  TabBar(tabs: const [
           Text('Employes', style: TextStyle(fontSize: 20)),
           Text('Bureaux', style: TextStyle(fontSize: 20)),
           Text('Electeur', style: TextStyle(fontSize: 20)),
         ], onTap: (int index){
           tabIndex = index;
           _incrementCounter();
         }),
       ),
       floatingActionButton: getFlotting(),
    ));

  }
  
  


  getFlotting() {
    if (MyHomePage.who == 'admin') {
      if(tabIndex == 0) {
        return FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return CreateEmploye();
              });
        },
        tooltip: 'Nouvelle Section',
        child: const Icon(Icons.add),
      );
      }
    }else if (MyHomePage.who == 'employe') {
      if(tabIndex == 1) {

        return FloatingActionButton(
        onPressed: () async {
          BackendConfig.etat = this;
          showDialog(context: context, builder: (context){

            return CreateBureau();
          });
        },
        tooltip: 'Nouvelle Section',
        child: const Icon(Icons.add),
      );
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    Section.etat = this;
    // BackendConfig.etat = this;
    Employe.etat = this;
  }
}
getListeSectionItem(BuildContext context) {

  return Container(
    alignment: Alignment.center,
    child: MyHomePage.currentUser.organisation == null
        ? const Text('Vous devez creer une organisation d\'abord !!')
        : FutureBuilder(
        future: EmployeDTO.getAll(),
        builder: (context, AsyncSnapshot<http.Response> response) {
          if (response.hasError) {
            return const Text('Il y\'a eu une erreur');
          } else if (response.hasData) {
            String? a = response.data?.body;
            String b = a!;
            dynamic r = jsonDecode(b);
            int taille = r.length;
            if (taille == 0) {
              return const Text(
                  'Cette section ne contient pas d\'employes');
            }
            Employe.liste = [];
            return ListView(children: [
              for (int i = 0; i < taille; i++)
                Employe(EmployeDTO.toEmploye(r[i])),
            ]);
          }
          return Text('Liste vide');
        }),
  );
}

getPopupMenuButton(BuildContext context) {
  return PopupMenuButton(
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem(
          child: const Text("chef"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Scaffold()));
          },
        ),
        PopupMenuItem(
          child: const Text("Bureaux de vote"),
          onTap: () {
            // Navigator.pushReplacementNamed(context, '/home');
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => BureauPage(BackendConfig.curenBureau!)));
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => BureauPage(BackendConfig.curenBureau!)));

          },
        ),
        PopupMenuItem(
          child: const Text("employes"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Scaffold()));
          },
        ),
      ];
    },
    onSelected: (value) => {},
  );
}
