import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/domain/entities/enemy.dart';

/// Immutable state holding every active [Enemy] of a level plus its spawn cap.
class EnemyState<T extends Enemy> {
  final List<T> enemies;
  final int maxEnemies;

  EnemyState({
    this.enemies = const [],
    this.maxEnemies = 5,
  });

  EnemyState<T> copyWith({
    List<T>? enemies,
    int? maxEnemies,
  }) {
    return EnemyState(
      enemies: enemies ?? this.enemies,
      maxEnemies: maxEnemies ?? this.maxEnemies,
    );
  }
}

/// Presentation contract every enemy notifier shares (spawning, movement, AI).
abstract class EnemyNotifier<T extends Enemy>
    extends StateNotifier<EnemyState<T>> {
  EnemyNotifier(super.initialState);

  void resetData(bool isTutorialMode);
  void addEnemy({double xCoords = 500});
  void updateXCoords(double distance);
  bool canMove();
  bool canMoveLeft(double distance);
  bool canMoveRight(double distance);
  bool isPlayerColliding(double playerX, T enemy);
  void startMoving();
  void isAnyEnemyNear(double playerX);
  void takeDamage(double damage);
}
