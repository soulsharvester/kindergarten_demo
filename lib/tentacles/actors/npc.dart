import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../wanderer.dart';

class NPC extends SpriteComponent with HasGameRef<WandGame>, CollisionCallbacks {
  final int npcId;
  final String npcName;
  int mood;
  List<String> dialogueLines;

  NPC({
    required Vector2 position,
    required Vector2 size,
    required this.npcId,
    required this.npcName,
    this.mood = 0,
    required this.dialogueLines,
  }) : super(position: position, size: size, anchor: Anchor.bottomCenter) {
    add(RectangleHitbox());
  }

  void triggerDialogue() {
    gameRef.startDialogue(this);
  }

  void changeMood(int amount) {
    mood = (mood + amount).clamp(-10, 10);
  }
}