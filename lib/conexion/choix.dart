import 'package:election/conexion/login.dart';
import 'package:election/main.dart';
import 'package:flutter/material.dart';

class Choice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              height: 250,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              // color: Color(0x424242),
              width: 450,
              child: ListView(children: [
                Center(
                  child: Title(
                      color: Colors.white,
                      child: const Text(
                        "Qui etes vous ?",
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
                ElevatedButton(
                    onPressed: () {
                      MyHomePage.who = 'admin';
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                      // Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Je suis un Admin')),
                const SizedBox(
                  height: 16.0,
                  width: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      MyHomePage.who = 'employe';
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text('Je suis un Employe')),
              ])),
        ));
  }
}
