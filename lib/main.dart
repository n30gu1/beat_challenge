import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: BeatChallenge.new));
}

class BeatChallenge extends FlameGame {
  @override
  void render(Canvas canvas) {}

  @override
  void update(double dt) {}

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
}
