import 'package:election/backend/machine.dart';
import 'package:election/candidat/candidat_button.dart';
import 'package:election/main.dart';
import 'package:election/tools/qr_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../election/election_page.dart';

class MachinePage extends StatefulWidget {
  late MachineDTO bureauDTO;

  MachinePage(this.bureauDTO);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MachinePage(bureauDTO);
  }
}

class _MachinePage extends State<MachinePage> {
  late MachineDTO machine;
  late String message = '';
  bool voter = false;
  _MachinePage(this.machine);

  late List<String> pageList = ['Voter', 'Electeur', 'Employe', 'Info'];
  late String page = 'Electeur';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // getOrg();
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine a voter'),
      ),
      // drawer: MyHomePage.who=='admin'?null: const MonDrawer(),
      body: voter?createListeCandidat(context, machine, candidatList): Column(
        children:  [
          ListTile(
            title: Center(
              child: Text(message,
                  style: const TextStyle(color: Colors.red, height: 18)),
            ),
          ),
          // Center(child: Text(message, style: const TextStyle(color: Colors.red, height: 18)),),
          MyQRCode.displayQRCode(machine.id!),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          machine.isMachineReady(MyHomePage.currentEMploye.id!).then((value) => {
                if (value == 1)
                  {
                    setState(() {
                      voter = true;
                      CandidatButton.curentMachine = machine;
                    })
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Scaffold()))
                  }
                else if (value == 0)
                  {
                    setState(() {
                      message =
                          "Faites vous valider par un responsable puis scanner le qrcode ci dessous";
                    })
                  }
              });
        },
        child: const Text('Voter'),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
