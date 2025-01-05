import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class DogState {
  final double xCoords;
  final double width;
  final double speed;
  final ShadowAnimations currentState;
  final Directions currentDirection;

  DogState({
    this.xCoords = 100,
    this.width = 80,
    this.speed = 0.2,
    this.currentState = ShadowAnimations.sit,
    this.currentDirection = Directions.left,
  });

  DogState copyWith({
    double? xCoords,
    double? width,
    double? speed,
    ShadowAnimations? currentState,
    Directions? currentDirection,
  }) {
    return DogState(
      xCoords: xCoords ?? this.xCoords,
      width: width ?? this.width,
      speed: speed ?? this.speed,
      currentState: currentState ?? this.currentState,
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

  void updateState(ShadowAnimations currentState) {
    state = state.copyWith(currentState: currentState);
  }

  void updateDirection(Directions currentDirection) {
    state = state.copyWith(currentDirection: currentDirection);
  }

  void updateXCoords(double distance) {
    final newPosition = state.xCoords - distance;
    state = state.copyWith(xCoords: newPosition);
  }

  void stopMovement() {
    updateState(ShadowAnimations.sit);
  }

  bool isPlayerBetweenTheLimitsAndWalking() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits &&
        playerState.currentState == PlayerAnimations.walk;
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
    updateState(ShadowAnimations.walk);
    move(distance);
  }

  void handlePlayerNear(double playerX) {
    updateState(isPlayerBetweenTheLimitsAndWalking()
        ? ShadowAnimations.sit
        : ShadowAnimations.walk);
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
    updateState(ShadowAnimations.walk);
  }

  void _stopMovingAway(Timer timer) {
    timer.cancel();
    updateDirection(Directions.right);
    updateState(ShadowAnimations.bark);
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
    updateState(ShadowAnimations.walk);
  }

  void _stopMovingBack(Timer timer) {
    timer.cancel();
    updateState(ShadowAnimations.sit);
  }
}

final dogProvider = StateNotifierProvider.autoDispose<DogNotifier, DogState>((ref) {
  return DogNotifier(ref);
});
