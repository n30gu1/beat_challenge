import 'dart:ffi';

import 'package:flame/components.dart';

class QuarterRest extends SpriteComponent with HasGameRef {
  QuarterRest() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('quarter_rest.png');
    position = gameRef.size / 2;
  }
}

class DoubleEighthNote extends SpriteComponent with HasGameRef {
  DoubleEighthNote() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('double_eighth.png');
    position = gameRef.size / 2;
  }
}
