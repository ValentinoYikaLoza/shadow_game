import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/game_object.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class CoinState {
  final List<Coin> coins;

  CoinState({
    this.coins = const [],
  });

  CoinState copyWith({
    List<Coin>? coins,
  }) {
    return CoinState(
      coins: coins ?? this.coins,
    );
  }
}

class Coin extends GameObject {
  final bool isCoinCollected;
  final double coinValue;

  Coin({
    super.xCoords = 600,
    super.width = 5,
    this.coinValue = 1,
    this.isCoinCollected = false,
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

class CoinNotifier extends StateNotifier<CoinState>
    with CollisionMixin<CoinState> {
  CoinNotifier(this.ref) : super(CoinState());
  
  @override
  final Ref ref;

  void resetData() {
    state = CoinState();
  }

  void addCoin({double initialPosition = 600, double coinValue = 1}) {
    state = state.copyWith(
      coins: [
        ...state.coins,
        Coin(xCoords: initialPosition, coinValue: coinValue)
      ],
    );
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        coins: state.coins.map((coin) {
      final newPosition = coin.xCoords - distance;

      if (canMove()) return coin;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return coin;

      return coin.copyWith(
        xCoords: newPosition,
      );
    }).toList());
  }

  void isAnyCoinNear(double playerX) {
    state = state.copyWith(
      coins: state.coins.map((coin) {
        if (isPlayerColliding(playerX, coin) && !coin.isCoinCollected) {
          ref.read(playerProvider.notifier).addCoins(coin.coinValue);
          return coin.copyWith(isCoinCollected: true);
        }
        return coin;
      }).toList(),
    );
  }
}

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>((ref) {
  return CoinNotifier(ref);
});
