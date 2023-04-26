
import 'dart:convert';

import 'package:election/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'election.dart';

abstract class BackendConfig{

  static const String host = "http://localhost:3000";
  static String token = '';
  static State? etat;
  static ElectionDTO? curenElectifon;


  // MyHomePage.currentUser

  Future<bool> save(String path, {String token=''}) async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/$path"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(toJson())
    );
    // return await logUserIn(res);
    // print(jsonEncode(res.body));
    // print(res.body);

    return true;
  }

  static Future<http.Response> getAll(String path, String id) async {
    var res = await http.get(Uri.parse("${BackendConfig.host}/$path/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        }
    );
    // return await logUserIn(res);
    return res;
  }


  static Future<http.Response> delete(String path, String id) async {
     var res = await http.delete(Uri.parse("${BackendConfig.host}/$path/$id"),
         headers: <String, String>{
           'Content-Type': 'application/json',
           'authorization': 'Bearer $token'
         }
     );
     return res;
  }
  toJson();
  // save();
  // save();


}