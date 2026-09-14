import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

enum GameState { menu, playing, paused, dialogue }

class KindergartenGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  GameState state = GameState.menu;
  TiledComponent? currentMap;

  static const double targetWidth = 480; //camera resolution
  static const double targetHeight = 270;

  @override
  Future onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(targetWidth, targetHeight), //make resolution fixed
    );


    pauseEngine(); //dont do any logic when on start menu
  }

  Future startNewGame() async {
    overlays.remove('StartMenu');
    resumeEngine();
    state = GameState.playing;

    await loadSchoolMap('school_yard.tmx');
  }

  Future loadSchoolMap(String mapFileName) async {
    if (currentMap != null) {
      world.remove(currentMap!);
    }

    try {
    } catch (e) {
      debugPrint("Tilemap '$mapFileName' ready to be loaded once asset is provided.");
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (state == GameState.playing && currentMap == null) {
      final paint = Paint()..color = const Color(0xFF388E3C); //placeholder
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        paint,
      );

      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Map Placeholder (Waiting for Tiled Asset)',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(size.x / 2 - 150, size.y / 2));
    }
  }
}