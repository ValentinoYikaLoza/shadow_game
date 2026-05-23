import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CoordinateText extends TextComponent {
  CoordinateText({
    required Vector2 position,
    required double fontSize,
    required Color color,
  }) : super(
          text: '',
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontSize: fontSize,
            ),
          ),
          position: position,
        );

  void updateCoordinates(Vector2 position) {
    text =
        'L: ${position.x.toStringAsFixed(2)}, R: ${position.y.toStringAsFixed(2)}';
  }
}
