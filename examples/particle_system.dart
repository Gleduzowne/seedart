import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleSystem extends StatelessWidget {
  final double animationValue;
  final int particleCount;
  final double speed;

  const ParticleSystem({
    required this.animationValue,
    this.particleCount = 100,
    this.speed = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: ParticlePainter(
          progress: animationValue,
          particleCount: particleCount,
          speed: speed,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double progress;
  final int particleCount;
  final double speed;
  final Random random = Random(42); // Fixed seed for deterministic output

  ParticlePainter({
    required this.progress,
    required this.particleCount,
    required this.speed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    for (var i = 0; i < particleCount; i++) {
      final seedX = random.nextDouble();
      final seedY = random.nextDouble();
      final seedHue = random.nextDouble();

      final x = size.width * ((seedX + progress * speed) % 1.0);
      final y = size.height *
          ((seedY + math.sin(progress * math.pi * 2) * 0.2) % 1.0);
      final hue = (seedHue + progress) % 1.0;

      paint.color = HSVColor.fromAHSV(
        0.8,
        hue * 360,
        1.0,
        1.0,
      ).toColor();

      canvas.drawCircle(Offset(x, y), 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
