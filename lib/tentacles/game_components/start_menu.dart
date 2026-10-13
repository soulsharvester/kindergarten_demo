import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../wanderer.dart';

class StartMenu extends StatefulWidget {
  static const String id = 'StartMenu';
  final WandGame game;

  const StartMenu({super.key, required this.game});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  late bool _keyPressed;

  @override
  void initState() {
    super.initState();
    _keyPressed = widget.game.keyCheck;
    if (!_keyPressed) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && !_keyPressed) {
      setState(() {
        _keyPressed = true;
        widget.game.keyCheck = true;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !_keyPressed
              ? _buildPressAnyKeyPrompt()
              : _buildMenuContent(),
        ),
      ),
    );
  }

  Widget _buildPressAnyKeyPrompt() {
    return Column(
      key: const ValueKey('PressAnyKeyPrompt'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'The Wanderer',
          style: TextStyle(
            fontSize: 42,
            fontFamily: 'HomemadeApple',
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            letterSpacing: 4,
          ),
        ),
        SizedBox(height: 40),
        Text(
          'PRESS ANY KEY TO CONTINUE',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuContent() {
    return Column(
      key: const ValueKey('StartMenuContent'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'The Wanderer',
          style: TextStyle(
            fontSize: 42,
            fontFamily: 'HomemadeApple',
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'By Hamza Saif',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          ),
          onPressed: () => widget.game.startNewGame(),
          child: const Text('Start Monday', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white54),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          onPressed: () {},
          child: const Text('Inventory', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}