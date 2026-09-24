import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import '../game_components/maps_logic/obstacle.dart';
import '../wanderer.dart';

enum PlayerState { idle, walkLeft, walkRight, walkUp, walkDown }

class Player extends SpriteAnimationGroupComponent<PlayerState> with HasGameRef<WandGame>, KeyboardHandler, CollisionCallbacks {
  final double moveSpeed = 100.0;
  Vector2 velocity = Vector2.zero();
  final double stepTime = 0.15;
  bool _collidedX = false;
  bool _collidedY = false;

  Player({required Vector2 position})
      : super(position:
  position,
      size: Vector2(16,32),
      anchor: Anchor.bottomCenter);

  bool get isCulled => false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      RectangleHitbox(
        position: Vector2(0, 16), //takes double leg
        size: Vector2(16, 16),
      ),
    );
    final spriteSheet = await gameRef.images.load('Characters/Bob_16x16.png');
    final sheet = SpriteSheet(
      image: spriteSheet,
      srcSize: Vector2(16, 32),
    );

    animations = {
      PlayerState.idle: sheet.createAnimation(row: 2, stepTime: stepTime, from: 18, to: 24),
      PlayerState.walkLeft: sheet.createAnimation(row: 2, stepTime: stepTime, from: 12, to: 18),
      PlayerState.walkUp: sheet.createAnimation(row: 2, stepTime: stepTime, from: 6, to: 12),
      PlayerState.walkRight: sheet.createAnimation(row: 2, stepTime: stepTime, from: 0, to: 6),
      PlayerState.walkDown: sheet.createAnimation(row: 2, stepTime: stepTime, from: 18, to: 24),
    };

    current = PlayerState.idle;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Obstacle) {
      if (velocity.x != 0) _collidedX = true;
      if (velocity.y != 0) _collidedY = true;
    }
  }

  void _updateAnimations() {
    if (velocity.x < 0) {
      current = PlayerState.walkLeft;
    } else if (velocity.x > 0) {
      current = PlayerState.walkRight;
    } else if (velocity.y < 0) {
      current = PlayerState.walkUp;
    } else if (velocity.y > 0) {
      current = PlayerState.walkDown;
    } else {
      current = PlayerState.idle;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      velocity.x = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      velocity.x = 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      velocity.y = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      velocity.y = 1;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.state != GameState.playing) return;
    _updateAnimations();
    if (velocity.isZero()) return;
    final moveStep = velocity.normalized() * moveSpeed * dt;
    position.x += moveStep.x;

    if (_collidedX) {
      position.x -= moveStep.x;
      _collidedX = false;
    }
    position.y += moveStep.y;
    if (_collidedY) {
      position.y -= moveStep.y;
      _collidedY = false;
    }
  }
}