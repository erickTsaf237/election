import 'dart:async';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  late String annuler='';

  CountDownTimer(this.annuler);

  @override
  _CountDownTimerState createState() => _CountDownTimerState(annuler);
}

class _CountDownTimerState extends State<CountDownTimer> {
  int _counter = 15;
  late Timer _timer;
  late String annuler='';

  _CountDownTimerState(this.annuler);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0 && annuler.isEmpty) {
          _counter--;
        } else {
          _timer.cancel(); // Arrête le timer s'il n'a pas été annulé manuellement
          // Exécute l'action ici, comme l'affichage d'une boîte de dialogue ou la navigation vers une autre page
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_counter', // Affiche le compteur actuel
      style: TextStyle(fontSize: 24),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Annule le timer lorsqu'il n'est plus nécessaire
    super.dispose();
  }
}