import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_game/features/home/level_one_screen.dart';
import 'package:shadow_game/features/shared/widgets/background.dart';
import 'package:shadow_game/features/shared/widgets/coordinate_text.dart';
import 'package:shadow_game/features/shared/widgets/player.dart';

class Spider extends SpriteAnimationComponent {
  final FlameGame gameRef;
  final Background background;
  final Player player;
  bool isGoingRight;
  double offset = 30; // Offset para mantener la mascota al costado del jugador
  double speed = 0;
  double speedIncreased = 100;
  double inRange = 100;
  double attackRange = 50; // Espacio que deja antes de atacar
  SpriteAnimation? currentAnimation;
  late SpriteAnimation stayAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation walkAnimation;
  bool isChasing = false; // Bandera para indicar si está persiguiendo al jugador

  CoordinateText coordinates = CoordinateText(
      position: Vector2(40, -10), fontSize: 10, color: Colors.black);

  Spider({
    required this.gameRef,
    required this.background,
    required this.player,
    required SpriteAnimation animation,
    required Vector2 position,
    this.isGoingRight = true,
  }) : super(
          animation: animation,
          position: position,
          size: Vector2(125, 100),
        );

  // Agregar visibilidad
  bool isVisible = true;

  Future<void> loadAnimations() async {
    stayAnimation = await _loadAnimation('spider/stay/stay.png', 5);
    attackAnimation = await _loadAnimation('spider/attack/attack.png', 16, 0.08);
    walkAnimation = await _loadAnimation('spider/walk/walk.png', 4);
  }

  Future<SpriteAnimation> _loadAnimation(String path, int length,
      [double fps = 0.15]) async {
    return gameRef.loadSpriteAnimation(
      path,
      SpriteAnimationData.sequenced(
        amount: length,
        stepTime: fps,
        textureSize: Vector2(120, 90),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    double distanceToPlayer = (player.position - position).length;

    if (distanceToPlayer < inRange) {
      isChasing = true; // Comenzar a perseguir al jugador
    }

    if (isChasing) {
      // Detener al jugador
      player.speed = 0;

      if (distanceToPlayer > attackRange) {
        // Mover la araña hacia el jugador
        Vector2 direction = (player.position - position).normalized();
        position += direction * speedIncreased * dt;
        currentAnimation = walkAnimation;
      } else {
        // Iniciar la animación de ataque
        currentAnimation = attackAnimation;
      }
    } else {
      // Reanudar el movimiento del jugador
      player.speed = player.speedIncreased;
      currentAnimation = stayAnimation;
    }

    isVisible = position.x < gameRef.size.x;

    // Usar la animación actual
    animation = currentAnimation ?? stayAnimation;

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
