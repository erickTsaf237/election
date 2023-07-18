import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

class MonFilePicker extends StatefulWidget {
  @override
  _MonFilePicker createState() => _MonFilePicker();
}

class _MonFilePicker extends State<MonFilePicker> {
  late String _fileName='';

  /*void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélectionner un fichier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Nom du fichier sélectionné :'),
            Text(_fileName!=''?_fileName: 'Aucun fichier sélectionné'),
            SizedBox(height: 16),
            const ElevatedButton(
              onPressed:null,// _openFileExplorer,
              child: Text('Ouvrir l\'explorateur de fichiers'),
            ),
          ],
        ),
      ),
    );
  }
}