import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Portal extends PositionComponent {
  final String targetMap;
  final Vector2 spawnPosition;

  Portal({
    required Vector2 position,
    required Vector2 size,
    required this.targetMap,
    required this.spawnPosition,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }
}