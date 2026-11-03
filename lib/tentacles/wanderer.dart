import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

import 'actors/npc.dart';
import 'actors/player.dart';
import 'game_components/dialogue_overlay.dart';
import 'game_components/maps_logic/obstacle.dart';
import 'game_components/maps_logic/portal.dart';
import 'game_components/start_menu.dart';
import 'game_components/pause_menu.dart';
import 'game_components/transition_overlay.dart';

enum GameState { menu, playing, paused, dialogue }

class WandGame extends FlameGame with HasCollisionDetection, TapCallbacks, HasKeyboardHandlerComponents {

  bool keyCheck = false;
  String? pendingTargetMap;
  Vector2? pendingSpawnPosition;
  bool isTransitioningMap = false;

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
    state = GameState.playing;

    if (player != null) {
      if (player!.isMounted) {
        world.remove(player!);
      }
      player = null;
    }

    await switchMap(
      targetMap: 'house.tmx',
      spawnPosition: Vector2(300, 150),
    );
    overlays.add('PauseButton');
  }

  Future<void> switchMap({
    required String targetMap,
    required Vector2 spawnPosition,
  }) async {
    if (isTransitioningMap) return;
    isTransitioningMap = true;

    pendingTargetMap = targetMap;
    pendingSpawnPosition = spawnPosition;

    if (!overlays.isActive(TransitionOverlay.id)) {
      overlays.add(TransitionOverlay.id);
    }
  }

  Future<void> performMapSwitch() async {
    if (pendingTargetMap == null || pendingSpawnPosition == null) return;

    world.children.whereType<Obstacle>().forEach((o) => world.remove(o));
    world.children.whereType<Portal>().forEach((p) => world.remove(p));
    world.children.whereType<NPC>().forEach((n) => world.remove(n));

    if (player == null) {
      player = Player(position: pendingSpawnPosition!)..priority = 100;
      await world.add(player!);
    } else {
      if (player!.isMounted) {
        world.remove(player!);
      }
      player = Player(position: pendingSpawnPosition!)..priority = 100;
      await world.add(player!);
    }
    await loadMap(pendingTargetMap!);

    camera.viewfinder.zoom = 2.5;
    camera.follow(player!);
    _updateCameraBounds();
  }

  void finishTransition() {
    overlays.remove(TransitionOverlay.id);
    isTransitioningMap = false;
    pendingTargetMap = null;
    pendingSpawnPosition = null;
  }

  Future<void> quitToMenu() async {
    overlays.remove(PauseMenu.id);
    overlays.remove('PauseButton');
    camera.stop();

    if (player != null) {
      if (player!.isMounted) {
        world.remove(player!);
      }
      player = null;
    }

    world.children.whereType<Obstacle>().forEach((o) => world.remove(o));
    world.children.whereType<Portal>().forEach((p) => world.remove(p));
    world.children.whereType<NPC>().forEach((n) => world.remove(n));

    isTransitioningMap = false;
    pendingTargetMap = null;
    pendingSpawnPosition = null;

    resumeEngine();
    await loadMenu();
  }

  Future<void> loadMap(String mapFileName) async {
    try {
      if (currentMap != null && currentMap!.isMounted) {
        world.remove(currentMap!);
      }
      currentMap = null;

      final newMap = await TiledComponent.load(
        mapFileName,
        Vector2.all(16),
        prefix: 'assets/tiles/',
      );

      currentMap = newMap;
      currentMap?.priority = 0;
      await world.add(currentMap!);

      if (state == GameState.menu) {
        _fitMapToScreen();
      } else {
        _updateCameraBounds();
      }

      final npcGroup = currentMap!.tileMap.getLayer<ObjectGroup>('NPCs');
      if (npcGroup != null) {
        for (final obj in npcGroup.objects) {
          final npcId = obj.properties.getValue<int>('npcId') ?? 1;
          final npcName = obj.properties.getValue<String>('npcName') ?? 'NPC';

          final npc = NPC(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
            npcId: npcId,
            npcName: npcName,
            dialogueLines: ['Hello wanderer!', 'Nice day for a walk.'],
          );
          await world.add(npc);
        }
      }

      final obstacleGroup = currentMap!.tileMap.getLayer<ObjectGroup>('Collisions');
      if (obstacleGroup != null) {
        for (final obj in obstacleGroup.objects) {
          final obstacle = Obstacle(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
          );
          await world.add(obstacle);
        }
      }

      final portalGroup = currentMap!.tileMap.getLayer<ObjectGroup>('Portals');
      if (portalGroup != null) {
        for (final obj in portalGroup.objects) {
          final targetMap = obj.properties.getValue<String>('targetMap') ?? '';
          final spawnX = obj.properties.getValue<double>('spawnX') ?? 0.0;
          final spawnY = obj.properties.getValue<double>('spawnY') ?? 0.0;

          final portal = Portal(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
            targetMap: targetMap,
            spawnPosition: Vector2(spawnX, spawnY),
          );
          await world.add(portal);
        }
      }
    } catch (e) {
      debugPrint("Error loading tilemap '$mapFileName': $e");
    }
  }

  void _updateCameraBounds() {
    if (currentMap == null) return;

    final mapWidth = currentMap!.tileMap.map.width * currentMap!.tileMap.map.tileWidth.toDouble();
    final mapHeight = currentMap!.tileMap.map.height * currentMap!.tileMap.map.tileHeight.toDouble();
    final halfViewportWidth = (camera.viewport.size.x / 2) / camera.viewfinder.zoom;
    final halfViewportHeight = (camera.viewport.size.y / 2) / camera.viewfinder.zoom;

    if (mapWidth < camera.viewport.size.x / camera.viewfinder.zoom ||
        mapHeight < camera.viewport.size.y / camera.viewfinder.zoom) {
      camera.setBounds(Rectangle.fromLTWH(0, 0, mapWidth, mapHeight));
      return;
    }
    camera.setBounds(
      Rectangle.fromLTWH(
        halfViewportWidth,
        halfViewportHeight,
        mapWidth - (halfViewportWidth * 2),
        mapHeight - (halfViewportHeight * 2),
      ),
    );
  }

  void _fitMapToScreen() {
    if (currentMap == null || size.x == 0 || size.y == 0) return;

    final mapWidth = (currentMap!.tileMap.map.width * currentMap!.tileMap.map.tileWidth).toDouble();
    final mapHeight = (currentMap!.tileMap.map.height * currentMap!.tileMap.map.tileHeight).toDouble();

    final scaleX = size.x / mapWidth;
    final scaleY = size.y / mapHeight;

    camera.stop();
    camera.viewfinder.zoom = scaleX > scaleY ? scaleX : scaleY;
    camera.viewfinder.position = Vector2(mapWidth / 2, mapHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (state == GameState.menu) {
      _fitMapToScreen();
    } else if (state == GameState.playing) {
      _updateCameraBounds();
    }
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

  NPC? activeNPC;

  void startDialogue(NPC npc) {
    state = GameState.dialogue;
    activeNPC = npc;
    pauseEngine();
    overlays.add(DialogueOverlay.id);
  }

  void closeDialogue() {
    overlays.remove(DialogueOverlay.id);
    activeNPC = null;
    state = GameState.playing;
    resumeEngine();
  }
}