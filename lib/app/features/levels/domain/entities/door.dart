import 'package:shadow_game/app/features/levels/domain/entities/game_object.dart';
import 'package:shadow_game/app/features/levels/domain/entities/sprites.dart';

/// Whether a door sends the player home (start) or to the next level (finish).
enum DoorType { start, finish }

/// A door placed at the entrance/exit of a level.
class Door extends GameObject {
  final DoorSprite currentSprite;
  final DoorType doorType;

  Door({
    super.xCoords = 100,
    this.currentSprite = DoorSprite.close,
    this.doorType = DoorType.start,
    super.width = 120,
  });

  @override
  Door copyWith({
    double? xCoords,
    DoorSprite? currentSprite,
    DoorType? doorType,
    double? width,
  }) {
    return Door(
      xCoords: xCoords ?? this.xCoords,
      currentSprite: currentSprite ?? this.currentSprite,
      doorType: doorType ?? this.doorType,
      width: width ?? this.width,
    );
  }
}
