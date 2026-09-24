import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Obstacle extends PositionComponent {
  Obstacle({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  } //basically draws over the collision rectangles u put on the tiled application
}