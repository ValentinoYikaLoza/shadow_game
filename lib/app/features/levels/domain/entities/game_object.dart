/// Base entity for every static object placed in a level (doors, chests, coins).
///
/// Pure domain model: it only describes *what* an object is (position + size),
/// never *how* it is rendered or moved. Subclasses live in `domain/entities`
/// and the runtime logic lives in `presentation/providers`.
abstract class GameObject {
  final double xCoords;
  final double width;

  GameObject({
    required this.xCoords,
    required this.width,
  });

  GameObject copyWith({
    double? xCoords,
    double? width,
  });
}
