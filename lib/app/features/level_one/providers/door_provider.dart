import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/game_object.dart';
import 'package:shadow_game/app/features/level_one/models/sprite.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

enum DoorType { start, finish }

class Door extends GameObject {
  final DoorSprite currentState;
  final DoorType doorType;

  Door({
    super.xCoords = 100,
    this.currentState = DoorSprite.close,
    this.doorType = DoorType.start,
    super.width = 120,
  });

  @override
  Door copyWith({
    double? xCoords,
    DoorSprite? currentState,
    DoorType? doorType,
    double? width,
  }) {
    return Door(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      doorType: doorType ?? this.doorType,
      width: width ?? this.width,
    );
  }
}

class DoorNotifier extends GameObjectNotifier<Door> {
  DoorNotifier(this.ref) : super(GameObjectState<Door>());
  final Ref ref;

  @override
  void resetData() {
    state = GameObjectState<Door>();
  }

  @override
  void addObject({double xCoords = 100, DoorType doorType = DoorType.start}) {
    state = state.copyWith(
      objects: [
        ...state.objects,
        Door(xCoords: xCoords, doorType: doorType)
      ],
    );
  }

  @override
  void updateXCoords(double distance) {
    state = state.copyWith(
      objects: state.objects.map((door) {
        final newPosition = door.xCoords - distance;

        if (canMove()) return door;

        if (!canMoveLeft(distance) || !canMoveRight(distance)) return door;

        return door.copyWith(
          xCoords: newPosition,
        );
      }).toList(),
    );
  }

  @override
  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  @override
  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  @override
  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  @override
  bool isPlayerColliding(double playerX, Door object) {
    final leftBoundary = object.xCoords;
    final rightBoundary = object.xCoords + object.width;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  @override
  void isAnyObjectNear(double playerX) {
    state = state.copyWith(
      objects: state.objects.map(
        (door) {
          return door.copyWith(
            currentState: isPlayerColliding(playerX, door)
                ? DoorSprite.open
                : DoorSprite.close,
          );
        },
      ).toList(),
    );
  }
}

final doorProvider = StateNotifierProvider<DoorNotifier, GameObjectState<Door>>((ref) {
  return DoorNotifier(ref);
});