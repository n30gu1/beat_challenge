import 'package:beat_challenge/cards.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: BeatChallenge.new));
}

class BeatChallenge extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(QuarterRest());
    add(DoubleEighthNote());
  }

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
}
