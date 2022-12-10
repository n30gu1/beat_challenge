import 'package:flame/components.dart';

class Card extends SpriteComponent with HasGameRef {
  Card(Vector2 position, Vector2 size, Sprite sprite)
      : super(position: position, size: Vector2(50, 100));
}
