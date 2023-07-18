





import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRCode{

  static displayQRCode(String data, {double? taille = 200.0}){
    return Center(
        child:QrImageView(
        data: data,
        version: QrVersions.auto,
        size: taille??200.0,
    ));
  }


}