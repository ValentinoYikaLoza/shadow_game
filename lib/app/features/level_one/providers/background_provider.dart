import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class BackgroundState {
  final double xCoords;
  final double backgroundPosition;
  final double rightLimit;

  BackgroundState({
    this.xCoords = 20,
    this.backgroundPosition = 0,
    this.rightLimit = 10000,
  });


  BackgroundState copyWith({
    double? xCoords,
    double? backgroundPosition,
    double? rightLimit,
  }) {
    return BackgroundState(
      xCoords: xCoords ?? this.xCoords,
      backgroundPosition: backgroundPosition ?? this.backgroundPosition,
      rightLimit: rightLimit ?? this.rightLimit,
    );
  }
}

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this.ref) : super(BackgroundState());
  final Ref ref;

  /// Restablece el estado de las arañas
  void resetData() {
    state = BackgroundState(); // Restaura el estado inicial
  }

  void updateXCoords(double distance) {
    if (!canMoveLeft(distance) || !canMoveRight(distance)) {
      return;
    }

    final newPosition = state.xCoords + distance;

    if (!canMove()) {
      state = state.copyWith(backgroundPosition: state.backgroundPosition - distance);
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
    final newPosition = state.xCoords +  distance;

    return newPosition < state.rightLimit;
  }

  setRightLimit(double rightLimit) {
    state = state.copyWith(
      rightLimit: rightLimit,
    );
  }
}

final backgroundProvider =
    StateNotifierProvider<BackgroundNotifier, BackgroundState>((ref) {
  return BackgroundNotifier(ref);
});
