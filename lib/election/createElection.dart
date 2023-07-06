import 'package:election/backend/election.dart';
import 'package:election/election/election.dart';
import 'package:flutter/material.dart';

// import 'package:flutter.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as pickertoto;
import 'package:intl/intl.dart';

import '../backend/config.dart';

// import 'package:flutter/foundation.dart';

class CreateElection extends StatelessWidget {
  late ElectionDTO? election;

  CreateElection({Key? key, this.election}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyCreateElection(
      election: election,
    );
  }
}

class MyCreateElection extends StatefulWidget {
  MyCreateElection({Key? key, this.election}) : super(key: key);
  late ElectionDTO? election;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCreateElection(election: election);
  }
}

class _MyCreateElection extends State<MyCreateElection> {
  late ElectionDTO? election;
  var loginController = TextEditingController();
  var libeleController = TextEditingController();
  var codeController = TextEditingController();
  var descController = TextEditingController();
  var valeurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final begin_date_controller = TextEditingController();
  final endin_date_controller = TextEditingController();



  Future<void> _selectDate(BuildContext context,
      {bool changeDay = false}) async {
    DateTime? selectedDate = DateTime.now();
    try {
      if (changeDay) {
        selectedDate = election!.begining_voting_time!;
        throw Error();
      }
      var heur = TimeOfDay.fromDateTime(election!.begining_voting_time!);
      selectedDate = election!.begining_voting_time!
          .subtract(Duration(days: 0, hours: heur.hour, minutes: heur.hour));
    } catch (e) {
      selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate!,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100));
      print('888888888888888888888888888888888888888888888888');
    }
    if (changeDay && selectedDate != null) {
      print('77777777777777777777777777');
      try {
        var heur = TimeOfDay.fromDateTime(election!.begining_voting_time!);
        var heur2 = TimeOfDay.fromDateTime(election!.ending_voting_time!);
        election!.ending_voting_time = selectedDate
            .add(Duration(days: 0, minutes: heur2.minute, hours: heur2.hour));
        election!.begining_voting_time = selectedDate
            .add(Duration(days: 0, minutes: heur.minute, hours: heur.hour));
        setState(() {
          endin_date_controller.text =
              election!.ending_voting_time!.toString();
          begin_date_controller.text =
              election!.begining_voting_time!.toString();
        });
        print('------------------------------------------');
        selectedDate = null;
      } catch (e) {}
    }
    if (selectedDate != null) {
      try {
        if (election!.begining_voting_time != null) {
          selectedDate = election!.begining_voting_time!;
        }
      } catch (e) {}
      var heur = await showTimePicker(
          helpText: 'Selectionner l\'heur de debut du vote.',
          useRootNavigator: true,
          cancelText: 'Annuller',
          confirmText: 'Valider2',
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate!));
      if (heur != null) {
        selectedDate =
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        election!.begining_voting_time = DateTime.tryParse((selectedDate
            .add(Duration(days: 0, hours: heur.hour, minutes: heur.minute))
            .toString()));
        setState(() {
          print('pppppppppppppppppppp${election!
              .begining_voting_time}    pppp $selectedDate');
          begin_date_controller.text =
              election!.begining_voting_time!.toString();
        });
        try {
          if (election!.ending_voting_time != null) {
            selectedDate = election!.ending_voting_time;
          }
        } catch (e) {}
        var heur2 = await showTimePicker(
            helpText: 'Selectionner l\'heur de fin du vote.',
            useRootNavigator: true,
            cancelText: 'Annuller',
            confirmText: 'Valider2',
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate!));
        if (heur2 != null) {
          var tmp = TimeOfDay.fromDateTime(selectedDate);
          selectedDate = selectedDate.subtract(
              Duration(days: 0, hours: tmp.hour, minutes: tmp.minute));
          election!.ending_voting_time = selectedDate
              .add(Duration(days: 0, hours: heur2.hour, minutes: heur2.minute));
          print(selectedDate);
          setState(() {
            endin_date_controller.text =
                election!.ending_voting_time!.toString();
          });
        }
      }
    }
  }

  _MyCreateElection({this.election}) {
    election ??= ElectionDTO('', '', DateTime.now(), 1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Title(
            color: Colors.white,
            child: const Text(
              "Nouvelle Election",
              style: TextStyle(
                  fontSize: 35,
                  decoration: TextDecoration.underline,
                  color: Colors.indigo),
            )),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ],
      content: Container(
          constraints: const BoxConstraints.tightFor(width: 450, height: 400),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          // height: 300,
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
          child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: libeleController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Libele'),
                    maxLength: 64,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre libele ';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.libele = value!,
                  ),
                  TextFormField(
                    controller: codeController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'Code'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le code';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.code = value!,
                  ),
                  TextFormField(
                    controller: valeurController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(labelText: 'valeur'),
                    maxLength: 12,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer la valeur du vote';
                      }
                      return null;
                    },

                    onSaved: (value) => election?.valeur = int.parse(value!),
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Date and time'),
                    keyboardType: TextInputType.datetime,
                    // initialValue: depence.id != null? DateFormat.yMMMMd().add_Hm().format(depence.createdAt):"",
                    controller: begin_date_controller,
                    readOnly: true,
                    onTap: () async {
                      await _selectDate(context);
                    },
                    enabled: true,
                    // initialValue: depence.createdAt.toString(),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the date';
                      }
                      return null;
                    },
                    // onSaved: (value) => depence.createdAt =
                    //     DateTime.parse(dateControler.text)
                  ),
                  TextFormField(
                    decoration:
                    const InputDecoration(labelText: 'Date and time'),
                    keyboardType: TextInputType.datetime,
                    // initialValue: depence.id != null? DateFormat.yMMMMd().add_Hm().format(depence.createdAt):"",
                    controller: endin_date_controller,
                    readOnly: true,
                    onTap: () async {
                      var a = await _selectDate(context);
                    },
                    enabled: true,
                    // initialValue: depence.createdAt.toString(),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please select the ending  period';
                      }
                      if (value.isNotEmpty) {
                        // print('${election!.ending_voting_time} oooo ${election!.begining_voting_time} oooo ${election!.ending_voting_time!.compareTo(election!.begining_voting_time!)}');
                        if(election!.ending_voting_time!.compareTo(election!.begining_voting_time!)<=0){
                          return 'Please select a date which later than the beginning date';
                        }

                      }
                      return null;
                    },
                    // onSaved: (value) => depence.createdAt =
                    //     DateTime.parse(dateControler.text)
                  ),
                  TextFormField(
                    controller: descController,
                    // initialValue: depence.id!= null? "${depence.libele}":"",
                    decoration: const InputDecoration(
                        hintText: 'Decrivez votre election',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                        ))),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 1000,
                    validator: (value) {
                      return null;
                    },

                    onSaved: (value) => election?.description = value!,
                  )
                  ,
                  Container(
                    // width: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var loged = await _submit(context);
                        if (loged == 1) {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                        } else if (loged == 0) {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                          print('echec de conn');
                        } else {
                          // Navigator.pushReplacementNamed(context, 'routeName');
                        }
                      },
                      style: const ButtonStyle(),
                      child: const Text('Valider'),
                    ),
                  )
                ],
              ))),
    );
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(election?.toJson());
      var loged = await election!.save('election', token: BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Election.etat?.setState(() {});
      }
    }
    return 0;
  }
}

class PlanVotingDay extends StatefulWidget {
  late ElectionDTO _electionDTO;

  PlanVotingDay(this._electionDTO);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlanVotingDay(_electionDTO);
  }
}

class _PlanVotingDay extends State<PlanVotingDay> {
  late ElectionDTO _electionDTO;
  final _formKey = GlobalKey<FormState>();
  final begin_date_controller = TextEditingController();
  final endin_date_controller = TextEditingController();

  _PlanVotingDay(this._electionDTO){
    endin_date_controller.text = _electionDTO.ending_voting_time.toString();
    begin_date_controller.text = _electionDTO.begining_voting_time.toString();
  }


  Future<void> _selectDate(BuildContext context,
      {bool changeDay = false}) async {
    DateTime? selectedDate = DateTime.now();
    try {
      if (changeDay) {
        selectedDate = _electionDTO.begining_voting_time!;
        throw Error();
      }
      var heur = TimeOfDay.fromDateTime(_electionDTO.begining_voting_time!);
      selectedDate = _electionDTO.begining_voting_time!
          .subtract(Duration(days: 0, hours: heur.hour, minutes: heur.hour));
    } catch (e) {
      selectedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate!,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100));
    }
    if (changeDay && selectedDate != null) {
      try {
        var heur = TimeOfDay.fromDateTime(_electionDTO.begining_voting_time!);
        var heur2 = TimeOfDay.fromDateTime(_electionDTO.ending_voting_time!);
        _electionDTO.ending_voting_time = selectedDate
            .add(Duration(days: 0, minutes: heur2.minute, hours: heur2.hour));
        _electionDTO.begining_voting_time = selectedDate
            .add(Duration(days: 0, minutes: heur.minute, hours: heur.hour));
        setState(() {
          endin_date_controller.text =
              _electionDTO.ending_voting_time!.toString();
          begin_date_controller.text =
              _electionDTO.begining_voting_time!.toString();
        });
        selectedDate = null;
      } catch (e) {}
    }
    if (selectedDate != null) {
      try {
        if (_electionDTO.begining_voting_time != null) {
          selectedDate = _electionDTO.begining_voting_time!;
        }
      } catch (e) {}
      var heur = await showTimePicker(
          helpText: 'Selectionner l\'heur de debut du vote.',
          useRootNavigator: true,
          cancelText: 'Annuller',
          confirmText: 'Valider2',
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate!));
      if (heur != null) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        _electionDTO.begining_voting_time = DateTime.tryParse((selectedDate
            .add(Duration(days: 0, hours: heur.hour, minutes: heur.minute)).toString()));
        setState(() {
          print('pppppppppppppppppppp${_electionDTO.begining_voting_time}    pppp $selectedDate');
          begin_date_controller.text =
              _electionDTO.begining_voting_time!.toString();
        });
        try {
          if (_electionDTO.ending_voting_time != null) {
            selectedDate = _electionDTO.ending_voting_time;
          }
        } catch (e) {}
        var heur2 = await showTimePicker(
            helpText: 'Selectionner l\'heur de fin du vote.',
            useRootNavigator: true,
            cancelText: 'Annuller',
            confirmText: 'Valider2',
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate!));
        if (heur2 != null) {
          var tmp = TimeOfDay.fromDateTime(selectedDate);
          selectedDate = selectedDate.subtract(Duration(days: 0, hours: tmp.hour, minutes: tmp.minute));
          _electionDTO.ending_voting_time = selectedDate
              .add(Duration(days: 0, hours: heur2.hour, minutes: heur2.minute));
          print(selectedDate);
          setState(() {
            endin_date_controller.text =
                _electionDTO.ending_voting_time!.toString();
          });
        }
      }
    }

    // _electionDTO.begining_voting_time = selectedDate;
    // txt.text(selectedDate);
    // depence.createdAt = selectedDate;
    // datecontroller.text =
    // "${DateFormat.yMMMMd().format(selectedDate)} ${heur != null ? " ${heur.hour}:${heur.minute}" : '00:00'}";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
        title: Container(
          alignment: Alignment.center,
          child: Title(
              color: Colors.white,
              child: const Text(
                "Date du vote",
                style: TextStyle(
                    fontSize: 35,
                    decoration: TextDecoration.underline,
                    color: Colors.indigo),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ],
        content: Container(
            constraints: const BoxConstraints.tightFor(width: 450, height: 400),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            // height: 300,
            decoration:
                BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
            child: Form(
                key: _formKey,
                child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Date and time'),
                        keyboardType: TextInputType.datetime,
                        // initialValue: depence.id != null? DateFormat.yMMMMd().add_Hm().format(depence.createdAt):"",
                        controller: begin_date_controller,
                        readOnly: true,
                        onTap: () async {
                          await _selectDate(context);
                        },
                        enabled: true,
                        // initialValue: depence.createdAt.toString(),

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the date';
                          }
                          return null;
                        },
                        // onSaved: (value) => depence.createdAt =
                        //     DateTime.parse(dateControler.text)
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Date and time'),
                        keyboardType: TextInputType.datetime,
                        // initialValue: depence.id != null? DateFormat.yMMMMd().add_Hm().format(depence.createdAt):"",
                        controller: endin_date_controller,
                        readOnly: true,
                        onTap: () async {
                          var a = await _selectDate(context);
                        },
                        enabled: true,
                        // initialValue: depence.createdAt.toString(),

                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select the ending  period';
                          }
                          if (value.isNotEmpty) {
                            print('${_electionDTO.ending_voting_time} oooo ${_electionDTO.begining_voting_time} oooo ${_electionDTO.ending_voting_time!.compareTo(_electionDTO.begining_voting_time!)}');
                            if(_electionDTO.ending_voting_time!.compareTo(_electionDTO.begining_voting_time!)<=0){
                              return 'Please select a date which later than the beginning date';
                            }

                          }
                          return null;
                        },
                        // onSaved: (value) => depence.createdAt =
                        //     DateTime.parse(dateControler.text)
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _selectDate(context, changeDay: true);
                              },
                              child: const Text('Change le jour ')),
                          ElevatedButton(
                              onPressed: () {
                                _submit(context);
                              },
                              child: Text('Valider'))
                        ],
                      )
                    ]))));
  }

  Future<int> _submit(BuildContext context) async {
    // jsonEncode(userBackend);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // print(election?.toJson());
      var loged = await _electionDTO.update('election/voting_date',
          token: BackendConfig.token);
      if (loged) {
        Navigator.pop(context);
        Election.etat?.setState(() {});
      }
    }
    return 0;
  }
}
