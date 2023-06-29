
import 'dart:convert';

import 'package:election/backend/section.dart';
import 'package:election/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'bureau_dto.dart';
import 'election.dart';

abstract class BackendConfig{

 static const String host = "http://localhost:3000";
 // static const String host = "https://organisations.adaptable.app";
  // static const String host = "http://192.168.43.19:3000";
  //http://192.168.43.240:4000/classes
  static String token = '';
  static State? etat;
  static ElectionDTO? curenElectifon;
  static SectionDTO? curenSection;
  static BureauDTO? curenBureau;
  //649055543065aecac697d54c


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

  Future<http.Response> save2(String path, {String token=''}) async {
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

    return res;
  }

  Future<bool> update(String path, {String token=''}) async {
    final res = await http.put(Uri.parse("${BackendConfig.host}/$path"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(toJson2())
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
  static Future<http.Response> getOne(String path, String id) async {
     var res = await http.get(Uri.parse("${BackendConfig.host}/$path/$id"),
         headers: <String, String>{
           'Content-Type': 'application/json',
           'authorization': 'Bearer $token'
         }
     );
     return res;
  }
  toJson();
  toJson2();
  // save();
  // save();


}