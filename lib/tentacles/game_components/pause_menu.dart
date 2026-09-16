import 'package:flutter/material.dart';
import '../wanderer.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final WandGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    double DeviceHeight = ((MediaQuery.of(context).size.height)/3)*2;
    double DeviceWidth = ((MediaQuery.of(context).size.width)/3);
    
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          height: DeviceHeight,
          width: DeviceWidth,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 280, // Gives the menu a fixed, polished card width
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.pause_circle_filled_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          game.resumeGame();
                        },
                        child: const Text(
                          'Resume',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => game.quitToMenu(),
                        child: const Text(
                          'Quit to Menu',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}