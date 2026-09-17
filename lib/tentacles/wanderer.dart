import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'actors/player.dart';
import 'game_components/start_menu.dart';
import 'game_components/pause_menu.dart';

enum GameState { menu, playing, paused, dialogue }

class WandGame extends FlameGame with HasCollisionDetection, TapCallbacks, HasKeyboardHandlerComponents {
  GameState state = GameState.menu;
  TiledComponent? currentMap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await loadMenu();
  }

  Future<void> loadMenu() async {
    state = GameState.menu;
    overlays.add(StartMenu.id);
    await loadMap('menu.tmx');
  }

  Player? player;

  Future<void> startNewGame() async {
    overlays.remove(StartMenu.id);
    await loadMap('house.tmx');

    currentMap?.priority = 0;
    player = Player(position: Vector2(100, 100))..priority = 100;
    await world.add(player!);

    camera.follow(player!);

    state = GameState.playing;
    overlays.add('PauseButton');
  }

  Future<void> quitToMenu() async {
    overlays.remove(PauseMenu.id);
    overlays.remove('PauseButton');
    camera.stop();
    if (player != null) {
      world.remove(player!);
      player = null;
    }
    resumeEngine();
    await loadMenu();
  }

  Future<void> loadMap(String mapFileName) async {
    if (currentMap != null) {
      world.remove(currentMap!);
    }//

    try {
      currentMap = await TiledComponent.load(
        mapFileName,
        Vector2.all(16),
        prefix: 'assets/tiles/',
      );

      await world.add(currentMap!);
      _fitMapToScreen();
    } catch (e) {
      debugPrint("Error loading tilemap '$mapFileName': $e");
    }
  }

  void _fitMapToScreen() {
    if (currentMap == null || size.x == 0 || size.y == 0) return;

    final mapWidth = currentMap!.tileMap.map.width * currentMap!.tileMap.map.tileWidth;
    final mapHeight = currentMap!.tileMap.map.height * currentMap!.tileMap.map.tileHeight;

    final scaleX = size.x / mapWidth;
    final scaleY = size.y / mapHeight;

    camera.viewfinder.zoom = scaleX > scaleY ? scaleX : scaleY;
    camera.viewfinder.position = Vector2(mapWidth / 2, mapHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _fitMapToScreen();
  }

  void pauseGame() {
    state = GameState.paused;
    overlays.remove('PauseButton');
    overlays.add(PauseMenu.id);
    pauseEngine();
  }

  void resumeGame() {
    state = GameState.playing;
    overlays.remove(PauseMenu.id);
    overlays.add('PauseButton');
    resumeEngine();
  }
}