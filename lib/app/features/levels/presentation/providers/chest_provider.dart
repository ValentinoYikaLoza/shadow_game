import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/domain/entities/chest.dart';
import 'package:shadow_game/app/features/levels/domain/entities/sprites.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/background_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/base/game_object_notifier.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/coin_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/player_provider.dart';

class ChestNotifier extends GameObjectNotifier<Chest> {
  ChestNotifier(this.ref) : super(GameObjectState<Chest>());
  final Ref ref;

  @override
  void resetData() {
    state = GameObjectState<Chest>();
  }

  @override
  void addObject({double xCoords = 600, double coinValue = 1}) {
    state = state.copyWith(
      objects: [...state.objects, Chest(xCoords: xCoords, coinValue: coinValue)],
    );
  }

  @override
  void updateXCoords(double distance) {
    state = state.copyWith(
      objects: state.objects.map((chest) {
        final newPosition = chest.xCoords - distance;

        if (canMove()) return chest;

        if (!canMoveLeft(distance) || !canMoveRight(distance)) return chest;

        return chest.copyWith(
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
  bool isPlayerColliding(double playerX, Chest object) {
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
      objects: state.objects.map((chest) {
        if (!isPlayerColliding(playerX, chest)) return chest;

        if (chest.currentSprite == ChestSprite.open && !chest.hasCoin) {
          _dropCoin(chest);
          return chest.copyWith(hasCoin: true);
        }

        return chest.copyWith(currentSprite: ChestSprite.open);
      }).toList(),
    );
  }

  void _dropCoin(Chest chest) {
    ref.read(coinProvider.notifier).addObject(
      xCoords: chest.xCoords + 50,
      coinValue: chest.coinValue,
    );
  }
}

final chestProvider = StateNotifierProvider<ChestNotifier, GameObjectState<Chest>>((ref) {
  return ChestNotifier(ref);
});