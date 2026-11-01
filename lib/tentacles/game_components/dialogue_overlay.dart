import 'package:flutter/material.dart';
import '../actors/npc.dart';
import '../wanderer.dart';

class DialogueOverlay extends StatefulWidget {
  static const String id = 'DialogueOverlay';
  final WandGame game;
  final NPC npc;

  const DialogueOverlay({
    super.key,
    required this.game,
    required this.npc,
  });

  @override
  State<DialogueOverlay> createState() => _DialogueOverlayState();
}

class _DialogueOverlayState extends State<DialogueOverlay> {
  int _currentLineIndex = 0;

  void _nextDialogue() {
    if (_currentLineIndex < widget.npc.dialogueLines.length - 1) {
      setState(() {
        _currentLineIndex++;
      });
    } else {
      widget.game.closeDialogue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentText = widget.npc.dialogueLines[_currentLineIndex];

    return Positioned(
      bottom: 24,
      left: 32,
      right: 32,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white, width: 3.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.npc.npcName,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Mood: ${widget.npc.mood}",
                    style: TextStyle(
                      color: widget.npc.mood >= 0 ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                currentText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: _nextDialogue,
                  child: Text(
                    _currentLineIndex < widget.npc.dialogueLines.length - 1
                        ? 'Next >'
                        : 'Close',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}