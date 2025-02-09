import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class RotatingCube extends StatelessWidget {
  final double animationValue;

  const RotatingCube({required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(animationValue * math.pi * 2)
        ..rotateY(animationValue * math.pi * 2),
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}