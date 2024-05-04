
import 'package:flutter_riverpod/flutter_riverpod.dart';

final positionProvider =
    StateNotifierProvider<PositionNotifier, PositionState>((ref) {
  return PositionNotifier(ref);
});

class PositionNotifier extends StateNotifier<PositionState> {
  PositionNotifier(this.ref) : super(PositionState());
  final StateNotifierProviderRef ref;

    changeX(double distance, double width){
      double newX = state.x;
      
      if (newX < width - 100){
        newX += distance;
      }

      state = state.copyWith(
        x: newX,
      );
    }
  }

class PositionState {
  final double x;
  final double? y;
  PositionState({
    this.x = 50,
    this.y,
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
