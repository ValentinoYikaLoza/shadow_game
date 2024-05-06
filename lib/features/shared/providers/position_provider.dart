import 'package:flutter_riverpod/flutter_riverpod.dart';

final positionProvider =
    StateNotifierProvider<PositionNotifier, PositionState>((ref) {
  return PositionNotifier(ref);
});

class PositionNotifier extends StateNotifier<PositionState> {
  PositionNotifier(this.ref) : super(PositionState());
  final StateNotifierProviderRef ref;

  moveRight(double distance, double limit) {
    double newX = state.x;

    if (newX < limit) {
      newX += distance;
    }

    state = state.copyWith(
      x: newX,
    );
  }

  moveLeft(double distance, double limit) {
    double newX = state.x;

    if (newX > limit) {
      newX -= distance;
    }

    state = state.copyWith(
      x: newX,
    );
  }

  moveUp(double distance, double limit) {
    double newY = state.y;

    if (newY > limit) newY -= distance;

    state = state.copyWith(
      y: newY,
    );
  }

  moveDown(double distance, double limit) {
    double newY = state.y;

    if (newY < limit) newY += distance;

    state = state.copyWith(
      y: newY,
    );
  }

  changeX(double newX) {
    state = state.copyWith(
      x: newX,
    );
  }

  changeY(double newY) {
    state = state.copyWith(
      y: newY,
    );
  }
}

class PositionState {
  final double x;
  final double y;
  PositionState({
    this.x = 50,
    this.y = 45,
  });

  PositionState copyWith({
    double? x,
    double? y,
  }) {
    return PositionState(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
