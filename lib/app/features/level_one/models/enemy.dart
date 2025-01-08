import 'package:flutter_riverpod/flutter_riverpod.dart';

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

abstract class EnemyNotifier<T extends Enemy> extends StateNotifier<EnemyState<T>> {
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