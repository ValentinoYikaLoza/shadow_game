import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/game_object.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class Coin extends GameObject {
  final bool isCoinCollected;
  final double coinValue;

  Coin({
    super.xCoords = 600,
    this.isCoinCollected = false,
    this.coinValue = 1,
    super.width = 5,
  });

  @override
  Coin copyWith({
    double? xCoords,
    bool? isCoinCollected,
    double? coinValue,
    double? width,
  }) {
    return Coin(
      xCoords: xCoords ?? this.xCoords,
      isCoinCollected: isCoinCollected ?? this.isCoinCollected,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

class CoinNotifier extends GameObjectNotifier<Coin> {
  CoinNotifier(this.ref) : super(GameObjectState<Coin>());
  final Ref ref;

  @override
  void resetData() {
    state = GameObjectState<Coin>();
  }

  @override
  void addObject({double xCoords = 600, double coinValue = 1}) {
    state = state.copyWith(
      objects: [...state.objects, Coin(xCoords: xCoords, coinValue: coinValue)],
    );
  }

  @override
  void updateXCoords(double distance) {
    state = state.copyWith(
      objects: state.objects.map((coin) {
        final newPosition = coin.xCoords - distance;

        if (canMove()) return coin;

        if (!canMoveLeft(distance) || !canMoveRight(distance)) return coin;

        return coin.copyWith(
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
  bool isPlayerColliding(double playerX, Coin object) {
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
      objects: state.objects.map((coin) {
        if (isPlayerColliding(playerX, coin) && !coin.isCoinCollected) {
          ref.read(playerProvider.notifier).addCoins(coin.coinValue);
          return coin.copyWith(isCoinCollected: true);
        }
        return coin;
      }).toList(),
    );
  }
}

final coinProvider =
    StateNotifierProvider<CoinNotifier, GameObjectState<Coin>>((ref) {
  return CoinNotifier(ref);
});
