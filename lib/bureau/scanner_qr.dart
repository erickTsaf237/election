import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:election/backend/bureau_dto.dart';
import 'package:election/backend/config.dart';
import 'package:election/backend/electeur_dto.dart';
import 'package:election/backend/employe.dart';
import 'package:election/main.dart';
import 'package:election/tools/qr_code.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

// void main() => runApp(const MaterialApp(home: MyHome()));

/*class QRScanner extends StatelessWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QRViewExample(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}*/

class QRViewExample extends StatefulWidget {
  BureauDTO bureau;

  QRViewExample(this.bureau, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState(bureau);
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  BureauDTO bureau;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _QRViewExampleState(this.bureau);

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  late ElecteurDTO electeur;

  @override
  Widget build(BuildContext context) {
    /*if(result!=null){
      if(result?.code!=null) {
        //Navigator.pop(context);
        controller?.pauseCamera();
        showDialog(context: context, builder: (context) {
          AlertDialog(
            actions: [ElevatedButton(onPressed: () {
              MyHomePage.currentEMploye.setElecteurIdIntoMyMyMachine(electeur.id!, BackendConfig.curenElectifon!.id!).then((value){
                if (value = true){
                  Navigator.pop(context);
                }
              });
            }
                , child: Text('Valider'))
            ],
            icon: Icon(Icons.person),
            content: FutureBuilder(
              future: ElecteurDTO.getOne(result!.code!.split('/')[0], autre: result!.code!.split('/')[1]),
              builder: (BuildContext context
                , AsyncSnapshot<ElecteurDTO?> reponse) {
              if (reponse.hasError) {
                return Center(child: Text('pas de connexion Internet'),);
              }
              else if (reponse.hasData) {
                print(reponse.data!.body);
                var a = jsonDecode(reponse.data!.body);
                try {
                  electeur = ElecteurDTO.fromDemande(a);
                  return Container(
                    child: Row(
                      children: [
                        Column(children: [
                          Container(child: Image.network(
                            '${BackendConfig.host}/${electeur.photo_electeur}',

                            height: 250,
                            width: 250,
                            errorBuilder: (context, objet, trace) {
                              return const Icon(
                                Icons.person, color: Colors.red, size: 80,);
                            },),),
                          MyQRCode.displayQRCode('${electeur.id}')
                        ],),
                        Column(children: [
                          ListTile(
                            title: Text('${electeur.nom} ${electeur.prenom}'),
                            subtitle: Text('Nom'),),
                          ListTile(title: Text('${electeur.date_naissance}'),
                              subtitle: Text('date de Naissace')),
                          // ListTile(title: Text('${electeur.nom} ${electeur.prenom}'), subtitle: Text('date de Naissace'))
                        ],)
                      ],
                    ),
                  );
                }catch(e){
                  print(e.toString());
                  return const Center(child: Text('Le bureau de cet electeur n\'est pas ici'),);
                }
              }
              return Center(child: CircularProgressIndicator(),);
            },

            ),
          );
          return Text('');
        });
      }
    }*/
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
                      softWrap: true,
                    )
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // setState(() {
      result = scanData;
      if (result != null) {
        if (result!.code != null) {
          Navigator.pop(context);
          controller?.pauseCamera();
          showDialog(
              context: context,
              builder: (context) {
                return FutureBuilder(
                  future: ElecteurDTO.getOne(result!.code!.split('/')[0],
                      autre: result!.code!.split('/')[1]),
                  builder: (BuildContext context,
                      AsyncSnapshot<ElecteurDTO?> reponse) {
                    if (reponse.hasError) {
                      return Center(
                        child: Text('pas de connexion Internet'),
                      );
                    } else if (reponse.hasData) {
                      print(reponse.data!);
                      if (reponse.data != null) {
                        try {
                          electeur = reponse.data!;
                          return AlertDialog(
                            title: const Text('Verifiez cet electeur'),
                            actions: [
                              ElevatedButton(
                                  onPressed: electeur.id_bureau != bureau.id!
                                      ? null
                                      : () {
                                          MyHomePage.currentEMploye
                                              .setElecteurIdIntoMyMyMachine(
                                                  BackendConfig
                                                      .curenElectifon!.id!, electeur.id!)
                                              .then((value) {
                                            if (value == true) {
                                              Navigator.pop(context);
                                            }
                                            else{

                                            }
                                          });
                                        },
                                  child: Text('Valider')),
                            ],
                            icon: Icon(Icons.person),
                            content: electeur.id_bureau != bureau.id!
                                ? const Center(
                                    child:
                                        Text('Ce bureau n\'est pas le votre', style: TextStyle(color: Colors.red, height: 20)),
                                  )
                                : ListView(
                                    children: [
                                      ListTile(
                                        title: Text(electeur.numero_de_cni),
                                        subtitle: const Text('Numero de CNI'),
                                      ),
                                      ListTile(
                                        title: Text(
                                            '${electeur.nom} ${electeur.prenom}'),
                                        subtitle: const Text('nom et prenom'),
                                      ),
                                      ListTile(
                                        title: Text(electeur.date_naissance),
                                        subtitle:
                                            const Text('date de naissance'),
                                      ),
                                      Container(
                                        child: Image.network(
                                          '${BackendConfig.host}/${electeur.photo_electeur}',
                                          height: 250,
                                          width: 250,
                                          errorBuilder:
                                              (context, objet, trace) {
                                            return const Icon(
                                              Icons.person,
                                              color: Colors.red,
                                              size: 80,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        } catch (e) {
                          print(e.toString());
                          return const Center(
                            child: Text(
                                'Le bureau de cet electeur n\'est pas ici'),
                          );
                        }
                      }
                      return Center(
                        child: Text('Il ne s\'agit pas d\'un electeur'),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              });
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous n\'avez pas de permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

/*return Container(
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Image.network(
                                          '${BackendConfig.host}/${electeur.photo_electeur}',
                                          height: 250,
                                          width: 250,
                                          errorBuilder:
                                              (context, objet, trace) {
                                            return const Icon(
                                              Icons.person,
                                              color: Colors.red,
                                              size: 80,
                                            );
                                          },
                                        ),
                                      ),
                                      MyQRCode.displayQRCode('${electeur.id}')
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                            '${electeur.nom} ${electeur.prenom}'),
                                        subtitle: Text('Nom'),
                                      ),
                                      ListTile(
                                          title: Text(
                                              '${electeur.date_naissance}'),
                                          subtitle: Text('date de Naissace')),
                                      // ListTile(title: Text('${electeur.nom} ${electeur.prenom}'), subtitle: Text('date de Naissace'))
                                    ],
                                  )
                                ],
                              ),
                            );

 */
