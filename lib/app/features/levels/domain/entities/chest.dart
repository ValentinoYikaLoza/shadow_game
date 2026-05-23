import 'package:shadow_game/app/features/levels/domain/entities/game_object.dart';
import 'package:shadow_game/app/features/levels/domain/entities/sprites.dart';

/// A chest the player can open to drop one or more coins.
class Chest extends GameObject {
  final ChestSprite currentSprite;
  final bool hasCoin;
  final double coinValue;

  Chest({
    super.xCoords = 600,
    this.currentSprite = ChestSprite.close,
    this.hasCoin = false,
    this.coinValue = 1,
    super.width = 60,
  });

  @override
  Chest copyWith({
    double? xCoords,
    ChestSprite? currentSprite,
    bool? hasCoin,
    double? coinValue,
    double? width,
  }) {
    return Chest(
      xCoords: xCoords ?? this.xCoords,
      currentSprite: currentSprite ?? this.currentSprite,
      hasCoin: hasCoin ?? this.hasCoin,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}
