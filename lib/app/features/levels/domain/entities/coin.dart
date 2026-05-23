import 'package:shadow_game/app/features/levels/domain/entities/game_object.dart';

/// A collectible coin worth [coinValue] currency.
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
