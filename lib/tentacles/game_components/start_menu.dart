import 'package:flutter/material.dart';
import '../game/wanderer.dart';

class StartMenu extends StatelessWidget {
  static const String id = 'StartMenu';
  final KindergartenGame game;

  const StartMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'KINDERGARTEN',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A Game of Choices, Secrets & Apples',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              ),
              onPressed: () => game.startNewGame(),
              child: const Text('START WEDNESDAY', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () {
              },
              child: const Text('CONTROLS & CARDS', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}