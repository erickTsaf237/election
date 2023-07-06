import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';


List<String> imageExtension = [
  'ai',
  '.bmp',
  'eps',
  'gif',
  'heic',
  'heif',
  'ico',
  'indd',
  'jpeg',
  'jpg',
  'nef',
  'orf',
  'pcx',
  'jfif',
  'png',
  'ps',
  'psd',
  'raw',
  'svg',
  'tif',
  'tiff',
  'webp',
  'xcf',
];

Future<File?> pickImage(State state, File? imageFile) async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: imageExtension)
        .then((value) {
      if (value != null) {
        // print(File(value.files.single.path!));
        File f = File(value.files.single.path!);
        String extension =
            Path.extension(value.files.single.path!).substring(1);
        print('$extension   ${imageExtension.contains(extension)}');
        return imageExtension.contains(extension)
            ? File(value.files.single.path!)
            : null;
      }
    });
  } else if (Platform.isAndroid || Platform.isIOS) {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  }
  return null;
}
