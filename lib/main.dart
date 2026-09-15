import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:kindergarten_game/tentacles/wanderer.dart';
import 'tentacles/game_components/start_menu.dart';
import 'tentacles/game_components/pause_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Wanderer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'IndieFlower'),
      home: const GameView(),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final WandGame _game;

  @override
  void initState() {
    super.initState();
    _game = WandGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<WandGame>(
        game: _game,
        initialActiveOverlays: const [StartMenu.id],
        overlayBuilderMap: {
          StartMenu.id: (BuildContext context, WandGame game) => StartMenu(game: game),
          PauseMenu.id: (BuildContext context, WandGame game) => PauseMenu(game: game),
          'PauseButton': (context, game) => Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.pause_circle_filled, size: 40, color: Colors.white),
              onPressed: () => game.pauseGame(),
            ),
          ),
        },
      ),
    );
  }
}