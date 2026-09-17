import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import '../wanderer.dart';

enum PlayerState { idle, walkLeft, walkRight, walkUp, walkDown }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<WandGame>, KeyboardHandler {
  final double moveSpeed = 100.0;
  Vector2 velocity = Vector2.zero();

  Player({required Vector2 position})
      : super(position:
  position,
      size: Vector2(16,32),
      anchor: Anchor.bottomCenter);

  bool get isCulled => false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = await gameRef.images.load('Characters/Bob_16x16.png');
    final sheet = SpriteSheet(
      image: spriteSheet,
      srcSize: Vector2(16, 32),
    );

    animations = {
      PlayerState.idle: sheet.createAnimation(row: 0, stepTime: 0.2, to: 1),
      PlayerState.walkLeft: sheet.createAnimation(row: 1, stepTime: 0.15, from: 12, to: 18),
      PlayerState.walkUp: sheet.createAnimation(row: 1, stepTime: 0.15, from: 6, to: 12),
      PlayerState.walkRight: sheet.createAnimation(row: 1, stepTime: 0.15, from: 0, to: 6),
      PlayerState.walkDown: sheet.createAnimation(row: 1, stepTime: 0.15, from: 18, to: 24),
    };

    current = PlayerState.idle;
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

    position += velocity.normalized() * moveSpeed * dt;
  }
}