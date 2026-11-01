import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../wanderer.dart';

class TransitionOverlay extends StatefulWidget {
  static const String id = 'TransitionOverlay';
  final WandGame game;
  final VoidCallback onMidpoint;
  final VoidCallback onComplete;

  const TransitionOverlay({
    super.key,
    required this.game,
    required this.onMidpoint,
    required this.onComplete,
  });

  @override
  State<TransitionOverlay> createState() => _TransitionOverlayState();
}

class _TransitionOverlayState extends State<TransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _midpointReached = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      if (_animation.value <= 0.0 && !_midpointReached) {
        _midpointReached = true;
        widget.onMidpoint();
        _controller.reverse();
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: IrisPainter(progress: _animation.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class IrisPainter extends CustomPainter {
  final double progress;

  IrisPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final center = Offset(size.width / 2, size.height / 2);

    final maxRadius = math.sqrt(center.dx * center.dx + center.dy * center.dy);
    final currentRadius = maxRadius * progress;

    final fullRect = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (currentRadius > 0) {
      final circlePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: currentRadius));

      final irisPath = Path.combine(
        PathOperation.difference,
        fullRect,
        circlePath,
      );
      canvas.drawPath(irisPath, paint);
    } else {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant IrisPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}