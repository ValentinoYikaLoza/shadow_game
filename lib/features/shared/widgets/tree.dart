import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_game/features/shared/widgets/coordinate_text.dart';

class TreeSprite extends SpriteComponent {
  final FlameGame gameRef;
  CoordinateText coordinates = CoordinateText(position: Vector2(40, -10), fontSize: 10, color: Colors.black);
  TreeSprite({
    required this.gameRef,
    required Sprite sprite,
    required Vector2 position,
  }) : super(
          sprite: sprite,
          position: position,
          size: Vector2(201, 201),
        );

  // Agregar visibilidad
  bool isVisible = true;

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (position.x + width < 0) {
      isVisible = false;
    } else if (position.x > gameRef.size.x) {
      isVisible = false;
    }else{
      isVisible = true;
    }
    coordinates.updateCoordinates(Vector2(position.x, position.x + width));
  }

  @override
  void render(Canvas canvas) {
    if (isVisible) {
      super.render(canvas);
      add(coordinates);
    }
  }
}
