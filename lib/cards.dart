import 'package:flame/components.dart';

class QuarterRest extends SpriteComponent with HasGameRef {
  QuarterRest() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('quarter_rest.png');
  }
}

class DoubleEighthNote extends SpriteComponent with HasGameRef {
  DoubleEighthNote() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('double_eighth.png');
  }
}

class EighthAndEighthRest extends SpriteComponent with HasGameRef {
  EighthAndEighthRest() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('eighth_eighth_rest.png');
  }
}

class QuadSixteenthNote extends SpriteComponent with HasGameRef {
  QuadSixteenthNote() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('quad_sixteenth.png');
  }
}

class QuarterNote extends SpriteComponent with HasGameRef {
  QuarterNote() : super(size: Vector2(210, 280));

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('quarter.png');
  }
}
