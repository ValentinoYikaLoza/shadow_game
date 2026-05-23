import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/domain/entities/game_object.dart';

/// Immutable state holding every instance of a [GameObject] subtype on screen.
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

/// Presentation contract every level-object notifier (door, chest, coin) shares.
abstract class GameObjectNotifier<T extends GameObject>
    extends StateNotifier<GameObjectState<T>> {
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
