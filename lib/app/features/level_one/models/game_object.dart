
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class GameObjectState<T extends GameObject> {
  final List<T> objects;

  GameObjectState({
    this.objects = const [],
  });

  GameObjectState<T> copyWith({
    List<T>? objects,
  }) {
    return GameObjectState(
      objects: objects ?? this.objects,
    );
  }
}

abstract class GameObjectNotifier<T extends GameObject> extends StateNotifier<GameObjectState<T>> {
  GameObjectNotifier(super.initialState);

  void resetData();
  void addObject({double xCoords = 600});
  void updateXCoords(double distance);
  bool canMove();
  bool canMoveLeft(double distance);
  bool canMoveRight(double distance);
  bool isPlayerColliding(double playerX, T object);
  void isAnyObjectNear(double playerX);
}