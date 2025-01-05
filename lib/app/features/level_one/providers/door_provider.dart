import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/models/game_object.dart';

enum DoorType { start, finish }

class Door extends GameObject {
  final DoorSprites currentState;
  final DoorType doorType;

  Door({
    super.xCoords = 600,
    super.width = 60,
    this.currentState = DoorSprites.close,
    this.doorType = DoorType.start,
  });

  @override
  Door copyWith({
    double? xCoords,
    DoorSprites? currentState,
    double? width,
  }) {
    return Door(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      width: width ?? this.width,
    );
  }
}

class DoorNotifier extends StateNotifier<DoorState>
    with CollisionMixin<DoorState> {
  DoorNotifier(this.ref) : super(DoorState());

  @override
  final Ref ref;

  void resetData() {
    state = DoorState();
  }

  void addDoor({double xCoords = 100, DoorType doorType = DoorType.start}) {
    state = state.copyWith(
        doors: [...state.doors, Door(xCoords: xCoords, doorType: doorType)]);
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        doors: state.doors.map((door) {
      final newPosition = door.xCoords - distance;

      if (canMove()) return door;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return door;

      return door.copyWith(xCoords: newPosition);
    }).toList());
  }

  void isAnyDoorNear(double playerX) {
    state = state.copyWith(
      doors: state.doors.map((door) {
        return door.copyWith(
          currentState: isPlayerColliding(playerX, door)
              ? DoorSprites.open
              : DoorSprites.close,
        );
      }).toList(),
    );
  }
}

class DoorState {
  final List<Door> doors;

  DoorState({this.doors = const []});

  DoorState copyWith({List<Door>? doors}) {
    return DoorState(doors: doors ?? this.doors);
  }
}

final doorProvider = StateNotifierProvider<DoorNotifier, DoorState>((ref) {
  return DoorNotifier(ref);
});
