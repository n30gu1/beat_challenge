import 'dart:math';
import 'package:flutter/material.dart';

class BeatMakerProvider extends ChangeNotifier {
  double _bpm = 80.0;
  double get bpm => _bpm;
  void setBpm(double bpm) {
    _bpm = bpm;
    notifyListeners();
  }

  List<int> makeBeat() {
    List<int> beat = [];

    for (int i = 0; i < 4; i++) {
      beat.add(Random().nextInt(6));
    }

    return beat;
  }
}
