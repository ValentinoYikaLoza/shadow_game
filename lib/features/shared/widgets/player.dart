import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_game/features/home/level_one_screen.dart';
import 'package:shadow_game/features/shared/widgets/background.dart';
import 'package:shadow_game/features/shared/widgets/coordinate_text.dart';
import 'package:shadow_game/features/shared/widgets/hud.dart';

class Player extends SpriteAnimationComponent {
  final FlameGame gameRef;
  final Background background;
  final HudComponent? hud;
  CoordinateText coordinates = CoordinateText(
      position: Vector2(-25, -10), fontSize: 10, color: Colors.black);
  bool isGoingRight;
  late double leftScreenLimitBuffer; // Buffer to trigger background movement
  late double rightScreenLimitBuffer; // Buffer to trigger background movement
  double speed = 0;
  double speedIncreased = 100;
  bool isMoving = false;
  bool isJumping = false;
  bool isDancing = false;
  bool isAttacking = false;
  bool isCutting = false;
  double jumpSpeed = 200;
  double gravity = 600;
  late double initialY;
  SpriteAnimation? currentAnimation;
  late SpriteAnimation stayAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation danceAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation cutAnimation;

  Player({
    required this.gameRef,
    required this.background,
    this.hud,
    required SpriteAnimation animation,
    required Vector2 position,
    this.isGoingRight = true,
  }) : super(
          animation: animation,
          position: position,
          size: Vector2(50, 50),
        ) {
    rightScreenLimitBuffer = gameRef.size.x - 200;
    leftScreenLimitBuffer = 100;
    initialY = position.y;
  }

  Future<void> loadAnimations() async {
    add(coordinates);
    stayAnimation = await _loadAnimation('player/stay/stay.png', 4);
    jumpAnimation = await _loadAnimation('player/jump/jump.png', 5);
    walkAnimation = await _loadAnimation('player/walk/walk.png', 8);
    danceAnimation = await _loadAnimation('player/dance/dance.png', 10);
    attackAnimation = await _loadAnimation('player/attack/attack.png', 4);
    cutAnimation = await _loadAnimation('player/cut/cut.png', 4);
  }

  Future<SpriteAnimation> _loadAnimation(String path, int length,
      [double fps = 0.15]) async {
    return gameRef.loadSpriteAnimation(
      path,
      SpriteAnimationData.sequenced(
        amount: length,
        stepTime: fps,
        textureSize: Vector2(50, 50),
      ),
    );
  }

  void updateDirection(bool newIsGoingRight) {
    if (isGoingRight != newIsGoingRight) {
      flipHorizontally();
      position.x += size.x * (isGoingRight ? 1 : -1);
      isGoingRight = newIsGoingRight;
    }
  }

  void movePlayer(bool isGoingRight) {
    updateDirection(isGoingRight);
    move();
  }

  void stopPlayer() {
    stopMoving();
  }

  void move() {
    isMoving = true;
    isDancing = false;
    if (isGoingRight) {
      speed = speedIncreased;
    } else {
      speed = speedIncreased * -1;
    }
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      isDancing = false;
      initialY = position.y;
      currentAnimation = jumpAnimation; // Actualizar la animación actual
    }
  }

  void toggleDance() {
    isDancing = !isDancing;
    if (isDancing) {
      currentAnimation = danceAnimation; // Actualizar la animación actual
    } else {
      currentAnimation = isMoving
          ? walkAnimation
          : stayAnimation; // Actualizar la animación actual
    }
  }

  void attack() {
    if (!isAttacking) {
      isAttacking = true;
      currentAnimation = attackAnimation; // Actualizar la animación actual
      // Añadir un temporizador para volver a la animación normal después de un tiempo
      Future.delayed(const Duration(milliseconds: 300), () {
        isAttacking = false;
        isDancing = false;
        currentAnimation = isMoving
            ? walkAnimation
            : stayAnimation; // Actualizar la animación actual
      });
    }
  }

  void chopTree() {
    if (!isCutting) {
      isCutting = true;
      currentAnimation = cutAnimation; // Actualizar la animación actual
      // Añadir un temporizador para volver a la animación normal después de un tiempo
      Future.delayed(const Duration(milliseconds: 300), () {
        isCutting = false;
        isDancing = false;
        currentAnimation = isMoving
            ? walkAnimation
            : stayAnimation; // Actualizar la animación actual
      });
    }
  }

  void stopMoving() {
    isMoving = false;
    speed = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    coordinates.updateCoordinates(Vector2(position.x, position.x + width));

    if (isJumping) {
      currentAnimation = jumpAnimation;
    } else if (isDancing) {
      currentAnimation = danceAnimation;
    } else if (isAttacking) {
      currentAnimation = attackAnimation;
    } else if (isCutting) {
      currentAnimation = cutAnimation;
    } else if (hud != null && hud!.joystick.delta.x != 0.0) {
      currentAnimation = walkAnimation;
    } else {
      stopPlayer();
      currentAnimation = stayAnimation;
    }

    // Permitir movimiento mientras se está saltando o bailando
    if (hud != null && hud!.joystick.delta.x != 0.0) {
      movePlayer(hud!.joystick.delta.x > 0.0);
      isMoving = true;
    } else {
      stopPlayer();
      isMoving = false;
    }

    // Usar la animación actual
    animation = currentAnimation ?? stayAnimation;
    // print((gameRef as LevelOneScreen).trees.first.position.x);
    // Check if the player is near the edge of the screen
    if (isMoving &&
        isGoingRight &&
        (position.x + width > rightScreenLimitBuffer)) {
      background.updateVelocity(speed);
      for (var tree in (gameRef as LevelOneScreen).trees) {
        tree.position.x -= (speed + 100) * dt;
      }
      speed = 0;
    } else if (isMoving &&
        !isGoingRight &&
        (position.x < leftScreenLimitBuffer)) {
      if ((gameRef as LevelOneScreen).trees.first.position.x >= 400) {
        background.updateVelocity(0);
        for (var tree in (gameRef as LevelOneScreen).trees) {
          tree.position.x -= 0 * dt;
        }
      } else {
        background.updateVelocity(speed);
        for (var tree in (gameRef as LevelOneScreen).trees) {
          tree.position.x -= (speed - 100) * dt;
        }
      }
      speed = 0;
    } else {
      background.updateVelocity(0);
    }

    if (isMoving) {
      position.x += speed * dt;
    } else {
      position.x += 0 * dt;
    }

    if (isJumping) {
      position.y -= jumpSpeed * dt;
      jumpSpeed -= gravity * dt;
      if (position.y >= initialY) {
        position.y = initialY;
        isJumping = false;
        jumpSpeed = 200; // Reset jump speed for the next jump
        animation = !isMoving ? stayAnimation : walkAnimation;
      }
    }
  }
}
