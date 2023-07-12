
import 'dart:convert';
import 'dart:io';

import 'package:election/backend/section.dart';
import 'package:election/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'bureau_dto.dart';
import 'election.dart';

abstract class BackendConfig{

 static const String host = "http://localhost:3000";
 //  static const String host = "https://organisations.adaptable.app";
 //  static const String host = "http://192.168.43.19:3000";
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
        body: jsonEncode(await toJson())
    );
    // return await logUserIn(res);
    // print(jsonEncode(res.body));
    // print(res.body);

    return true;
  }

 Future<http.Response> save3(String path, {String token=''}) async {
   final res = await http.post(Uri.parse("${BackendConfig.host}/$path"),
       headers: <String, String>{
         'Content-Type': 'application/json',
         'authorization': 'Bearer $token'
       },
       body: jsonEncode(await toJson())
   );
   // return await logUserIn(res);
   // print(jsonEncode(res.body));
   // print(res.body);

   return res;
 }

  Future<http.Response> save2(String path, {String token=''}) async {
    final res = await http.post(Uri.parse("${BackendConfig.host}/$path"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode( await toJson())
    );

    // return await logUserIn(res);
    // print(jsonEncode(res.body));
    // print(res.body);

    return res;
  }

 Future<bool> uploadFile(File file,String path,  String id) async {
   final request = http.MultipartRequest('PUT', Uri.parse("${BackendConfig.host}/$path"));
   final multipartFile = http.MultipartFile(
     'image',
     file.readAsBytes().asStream(),
     file.lengthSync(),
     filename: file.path.split('/').last,
   );
   request.files.add(multipartFile);
   request.fields['_id'] = id;
   final streamedResponse = await request.send();
   final response = await http.Response.fromStream(streamedResponse);
   if (response.statusCode == 200) {
     print('File uploaded');
     return true;
   } else {
     print('File upload failed with status ${response.statusCode}');
     return false;
   }
 }

  Future<bool> update(String path, {String token=''}) async {
    final res = await http.put(Uri.parse("${BackendConfig.host}/$path"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(await toJson2())
    );
    return true;
  }

  Future<http.Response> updateSomme(String path, String id, Map<String, String> object) async {
    print('${BackendConfig.host}/$path/${id}');
    final res = await http.put(Uri.parse("${BackendConfig.host}/$path/${id}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: jsonEncode(toJson())
    );
    print('${BackendConfig.host}/$path/${id}**********************');
    return res;
  }



  static Future<http.Response> getAll(String path, String id) async {
    print("${BackendConfig.host}/$path/$id");
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