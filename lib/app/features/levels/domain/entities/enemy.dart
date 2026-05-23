/// Base entity shared by every hostile character in a level.
///
/// Pure domain model (position, size and combat stats). Movement and AI live
/// in the matching `presentation/providers` notifier.
abstract class Enemy {
  final double xCoords;
  final double width;
  final double currentLives;
  final double maxLives;
  final double damage;

  Enemy({
    required this.xCoords,
    required this.width,
    required this.currentLives,
    required this.maxLives,
    required this.damage,
  });

  Enemy copyWith({
    double? xCoords,
    double? width,
    double? currentLives,
    double? maxLives,
    double? damage,
  });
}
