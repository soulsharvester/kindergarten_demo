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
          child: Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pause_rounded, size: 20, color: Colors.white,),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(PauseMenu.id);
                      game.resumeEngine();
                    },
                    child: const Text('Resume'),
                  ),
              TextButton(
                onPressed: () => game.quitToMenu(),
                child: const Text('Quit to Menu', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}