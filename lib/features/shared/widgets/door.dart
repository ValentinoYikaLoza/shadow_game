import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_game/features/home/level_one_screen.dart';
import 'package:shadow_game/features/shared/widgets/coordinate_text.dart';

class DoorSprite extends SpriteComponent with TapCallbacks{
  final FlameGame gameRef;
  final VoidCallback? onPressed;
  double rightLimit = 0;
  final Sprite openDoor;
  final Sprite closeDoor;
  CoordinateText coordinates = CoordinateText(
      position: Vector2(10, -20), fontSize: 10, color: Colors.black);
  DoorSprite({
    this.onPressed,
    required this.gameRef,
    required this.closeDoor,
    required this.openDoor,
    required Vector2 position,
  }) : super(
          sprite: openDoor,
          position: position,
          size: Vector2(88, 142),
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
    } else {
      isVisible = true;
    }
    coordinates.updateCoordinates(Vector2(position.x, position.x + width));
    if ((gameRef as LevelOneScreen).player.position.x > position.x &&
        (gameRef as LevelOneScreen).player.position.x <  position.x + width) {
      if (isVisible) {
        sprite = openDoor;
      }
      // print(
      //     '> abrir puerta: ${position.x} - ${(gameRef as LevelOneScreen).player.position.x} - ${position.x + width}');
    } else {
      sprite = closeDoor;
      // print(
      //     '> cerrar puerta: ${position.x} - ${(gameRef as LevelOneScreen).player.position.x} - ${position.x + width}');
    }
    position = position;
  }

  @override
  void render(Canvas canvas) {
    if (isVisible) {
      super.render(canvas);
      add(coordinates);
    }
  }

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
