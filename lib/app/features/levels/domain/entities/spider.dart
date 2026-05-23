import 'package:shadow_game/app/features/levels/domain/entities/animations.dart';
import 'package:shadow_game/app/features/levels/domain/entities/enemy.dart';

/// The spider enemy (and, as the last spawn, the level boss).
class Spider extends Enemy {
  final SpiderAnimation currentAnimation;
  final Directions currentDirection;

  Spider({
    super.xCoords = 500,
    this.currentAnimation = SpiderAnimation.stay,
    this.currentDirection = Directions.left,
    super.width = 300,
    super.currentLives = 5,
    super.maxLives = 5,
    super.damage = 1,
  });

  @override
  Spider copyWith({
    double? xCoords,
    SpiderAnimation? currentAnimation,
    Directions? currentDirection,
    double? width,
    double? currentLives,
    double? maxLives,
    double? damage,
  }) {
    return Spider(
      xCoords: xCoords ?? this.xCoords,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      currentDirection: currentDirection ?? this.currentDirection,
      width: width ?? this.width,
      currentLives: currentLives ?? this.currentLives,
      maxLives: maxLives ?? this.maxLives,
      damage: damage ?? this.damage,
    );
  }
}
