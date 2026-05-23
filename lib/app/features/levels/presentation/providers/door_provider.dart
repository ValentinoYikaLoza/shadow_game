import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/domain/entities/door.dart';
import 'package:shadow_game/app/features/levels/domain/entities/sprites.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/background_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/base/game_object_notifier.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/player_provider.dart';

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

    final isCollidingHorizontally = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return isCollidingHorizontally;
  }

  @override
  void isAnyObjectNear(double playerX) {
    state = state.copyWith(
      objects: state.objects.map(
        (door) {
          return door.copyWith(
            currentSprite: isPlayerColliding(playerX, door)
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