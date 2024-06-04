import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class ButtonSprite extends SpriteComponent with TapCallbacks {
  final VoidCallback? onPressed;
  ButtonSprite({
    this.onPressed,
    required Sprite super.sprite,
    required Vector2 super.position,
    super.size,
  });

  @override
  void onTapDown(TapDownEvent event) {
    opacity = 0.5; // Reduce la opacidad para indicar que se ha presionado
    onPressed!();
  }

  @override
  void onTapUp(TapUpEvent event) {
    opacity = 1.0; // Restaura la opacidad original cuando se suelta
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    opacity = 1.0; // Restaura la opacidad original si se cancela el tap
  }
}
