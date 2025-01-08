import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/animation.dart';
// import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class DogState {
  final double xCoords;
  final double width;
  final double speed;
  final ShadowAnimation currentAnimation;
  final Directions currentDirection;

  DogState({
    this.xCoords = 100,
    this.width = 80,
    this.speed = 0.2,
    this.currentAnimation = ShadowAnimation.sit,
    this.currentDirection = Directions.left,
  });

  DogState copyWith({
    double? xCoords,
    double? width,
    double? speed,
    ShadowAnimation? currentAnimation,
    Directions? currentDirection,
  }) {
    return DogState(
      xCoords: xCoords ?? this.xCoords,
      width: width ?? this.width,
      speed: speed ?? this.speed,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      currentDirection: currentDirection ?? this.currentDirection,
    );
  }
}

class DogNotifier extends StateNotifier<DogState> {
  DogNotifier(this.ref) : super(DogState());
  final Ref ref;

  Timer? _goAwayTimer;
  Timer? _goBackTimer;

  static const double followDistance = 50.0;
  static const deltaX = 10.0;

  void resetData() {
    state = DogState();
  }

  void updateAnimation(ShadowAnimation newAnimation) {
    state = state.copyWith(currentAnimation: newAnimation);
  }

  void updateDirection(Directions currentDirection) {
    state = state.copyWith(currentDirection: currentDirection);
  }

  void updateXCoords(double distance) {
    final newPosition = state.xCoords - distance;
    state = state.copyWith(xCoords: newPosition);
  }

  void stopMovement() {
    updateAnimation(ShadowAnimation.sit);
  }

  bool isPlayerBetweenTheLimitsAndWalking() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits &&
        playerState.currentAnimation == PlayerAnimation.walk;
  }

  bool isPlayerColliding(double playerX, DogState dog) {
    final leftBoundary = dog.xCoords - followDistance;
    final rightBoundary = dog.xCoords + dog.width + followDistance;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  void followPlayer(double playerX) {
    if (isPlayerColliding(playerX, state)) {
      handlePlayerNear(playerX);
    } else {
      handlePlayerMoving();
    }
  }

  void handlePlayerMoving() {
    final distance = deltaX * state.speed;
    updateAnimation(ShadowAnimation.walk);
    move(distance);
  }

  void handlePlayerNear(double playerX) {
    updateAnimation(isPlayerBetweenTheLimitsAndWalking()
        ? ShadowAnimation.sit
        : ShadowAnimation.walk);
    updateDirection(
        playerX > state.xCoords ? Directions.right : Directions.left);
  }

  void move(double distance) {
    updateXCoords(
        state.currentDirection == Directions.left ? distance : -distance);
  }

  void goAwayFromEnemy(double playerX, bool isEnemyNear) {
    if (!isEnemyNear) return;

    final distance = deltaX * state.speed;

    _goAwayTimer?.cancel();
    _goAwayTimer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if (playerX - state.xCoords <= 300) {
        _moveAway(distance);
      } else {
        _stopMovingAway(timer);
      }
    });
  }

  void _moveAway(double distance) {
    updateXCoords(distance);
    updateDirection(Directions.left);
    updateAnimation(ShadowAnimation.walk);
  }

  void _stopMovingAway(Timer timer) {
    timer.cancel();
    updateDirection(Directions.right);
    updateAnimation(ShadowAnimation.bark);
  }

  void goBackToThePlayer(double playerX) {
    final distance = deltaX * state.speed;

    _goBackTimer?.cancel();
    _goBackTimer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if (!isPlayerColliding(playerX, state)) {
        _moveBack(distance);
      } else {
        _stopMovingBack(timer);
      }
    });
  }

  void _moveBack(double distance) {
    updateXCoords(-distance);
    updateAnimation(ShadowAnimation.walk);
  }

  void _stopMovingBack(Timer timer) {
    timer.cancel();
    updateAnimation(ShadowAnimation.sit);
  }
}

final dogProvider = StateNotifierProvider.autoDispose<DogNotifier, DogState>((ref) {
  return DogNotifier(ref);
});
