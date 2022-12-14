import 'dart:async';
import 'dart:math';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

enum GameState { ready, playing, over }

class BeatPlayer {
  static BeatPlayer instance = BeatPlayer();

  void play() {
    FlameAudio.play('metronome.mp3');
  }
}

class GameService extends ChangeNotifier {
  int _score = 0;
  int get score => _score;

  void scoreIncrease() {
    _score++;
    notifyListeners();
  }

  void scoreDecrease() {
    _score--;
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    notifyListeners();
  }

  // BPM
  GameState _gameState = GameState.ready;
  GameState get gameState => _gameState;

  double _bpm = 60.0;
  double get bpm => _bpm;
  void setBpm(double bpm) {
    _bpm = bpm;
    notifyListeners();
  }

  DateTime? _lastTap = DateTime.now();
  DateTime? get lastTap => _lastTap;
  void updateLastTap() {
    _lastTap = DateTime.now();
    notifyListeners();
  }

  int _missCount = 0;
  int get missCount => _missCount;
  void increaseMissCount() {
    _missCount++;
    notifyListeners();
  }

  DateTime _lastBeat = DateTime.now();
  DateTime get lastBeat => _lastBeat;

  List<int> _beats = [];
  List<int> get beats => _beats;

  int? _currentBeatIndex;
  int? get currentBeatIndex => _currentBeatIndex;

  void makeBeat() {
    List<int> beat = [];

    for (int i = 0; i < 4; i++) {
      beat.add(Random().nextInt(5));
    }

    _beats = beat;
  }

  Future<void> playBeat() async {
    void play() {
      _lastBeat = DateTime.now();
      BeatPlayer.instance.play();
    }

    void checkMiss() {
      if (lastTap != null) {
        if (lastBeat.difference(lastTap!).inMilliseconds >= 60000 / bpm) {
          increaseMissCount();
        }
      } else {
        increaseMissCount();
      }

      if (score < -10 || missCount > 5) {
        stopBeat();
        _gameState = GameState.over;
        notifyListeners();
      }
    }

    makeBeat();
    _gameState = GameState.playing;
    while (gameState == GameState.playing) {
      for (int i = 0; i < _beats.length; i++) {
        if (gameState != GameState.playing) {
          break;
        }
        int beat = _beats[i];
        _currentBeatIndex = i;
        notifyListeners();

        switch (beat) {
          // Quarter Rest
          case 0:
            await Future.delayed(Duration(milliseconds: (60000 / bpm).round()));
            break;
          // Quarter Note
          case 1:
            play();
            await Future.delayed(Duration(milliseconds: (60000 / bpm).round()));
            checkMiss();
            break;
          // Eighth Note
          case 2:
            play();
            await Future.delayed(Duration(milliseconds: (30000 / bpm).round()));
            play();
            await Future.delayed(Duration(milliseconds: (30000 / bpm).round()));
            checkMiss();
            break;
          // Sixteenth Note
          case 3:
            play();
            await Future.delayed(Duration(milliseconds: (15000 / bpm).round()));
            play();
            await Future.delayed(Duration(milliseconds: (15000 / bpm).round()));
            play();
            await Future.delayed(Duration(milliseconds: (15000 / bpm).round()));
            play();
            await Future.delayed(Duration(milliseconds: (15000 / bpm).round()));
            checkMiss();
            break;
          // Eighth Note + Eighth Rest
          case 4:
            play();
            await Future.delayed(Duration(milliseconds: (60000 / bpm).round()));
            checkMiss();
            break;
          default:
        }
      }
      makeBeat();
      setBpm(bpm + 5);
    }
    _beats.clear();
    _currentBeatIndex = null;
    _score = 0;
    _missCount = 0;
    setBpm(60);
  }

  void stopBeat() {
    _gameState = GameState.ready;
    notifyListeners();
  }
}
