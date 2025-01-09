import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/providers/player_provider.dart';

class BackgroundState {
  final double xCoords;
  final double backgroundPosition;
  final double cavePosition;
  final double rightLimit;

  BackgroundState({
    this.xCoords = 20,
    this.backgroundPosition = 0,
    this.cavePosition = 10000,
    this.rightLimit = 10000,
  });

  BackgroundState copyWith({
    double? xCoords,
    double? backgroundPosition,
    double? cavePosition,
    double? rightLimit,
  }) {
    return BackgroundState(
      xCoords: xCoords ?? this.xCoords,
      backgroundPosition: backgroundPosition ?? this.backgroundPosition,
      cavePosition: cavePosition ?? this.cavePosition,
      rightLimit: rightLimit ?? this.rightLimit,
    );
  }
}

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this.ref) : super(BackgroundState());
  final Ref ref;

  void resetData() {
    state = BackgroundState();
  }

  void updateXCoords(double distance) {
    if (!canMoveLeft(distance) || !canMoveRight(distance)) {
      return;
    }

    final newPosition = state.xCoords + distance;

    if (!canMove()) {
      state = state.copyWith(
        backgroundPosition: state.backgroundPosition - distance,
        cavePosition: state.cavePosition - distance,
      );
    }

    state = state.copyWith(xCoords: newPosition);
  }

  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  bool canMoveLeft(double distance) {
    final newPosition = state.xCoords + distance;

    return newPosition > 20;
  }

  bool canMoveRight(double distance) {
    final newPosition = state.xCoords + distance;

    return newPosition < state.rightLimit;
  }

  void setRightLimit(double rightLimit) {
    state = state.copyWith(
      rightLimit: rightLimit,
    );
  }

  void addCave(double cavePosition) {
    state = state.copyWith(
      cavePosition: cavePosition,
    );
  }
}

final backgroundProvider =
    StateNotifierProvider<BackgroundNotifier, BackgroundState>((ref) {
  return BackgroundNotifier(ref);
});
