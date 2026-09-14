import 'package:flutter/material.dart';
import '../game/wanderer.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final KindergartenGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('PAUSED', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove(PauseMenu.id);
                    game.resumeEngine();
                  },
                  child: const Text('Resume'),
                ),
                TextButton(
                  onPressed: () {
                    game.overlays.remove(PauseMenu.id);
                    game.overlays.add('StartMenu');
                  },
                  child: const Text('Quit to Menu', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}