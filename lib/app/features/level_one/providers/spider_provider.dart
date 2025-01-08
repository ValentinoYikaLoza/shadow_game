import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/animation.dart';
// import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/models/enemy.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/dog_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/snackbar.dart';

class Spider extends Enemy {
  final SpiderAnimation currentState;
  final Directions currentDirection;

  Spider({
    super.xCoords = 500,
    this.currentState = SpiderAnimation.stay,
    this.currentDirection = Directions.left,
    super.width = 300,
    super.currentLives = 5,
    super.maxLives = 5,
    super.damage = 1,
  });
  @override
  Spider copyWith({
    double? xCoords,
    SpiderAnimation? currentState,
    Directions? currentDirection,
    double? width,
    double? currentLives,
    double? maxLives,
    double? damage,
  }) {
    return Spider(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      width: width ?? this.width,
      currentLives: currentLives ?? this.currentLives,
      maxLives: maxLives ?? this.maxLives,
      damage: damage ?? this.damage,
    );
  }
}

class SpiderNotifier extends EnemyNotifier<Spider> {
  SpiderNotifier(this.ref) : super(EnemyState<Spider>());

  final Ref ref;
  Timer? moveTimer;
  Timer? disapearTimer;

  @override
  void resetData(bool isTutorialMode) {
    state = EnemyState<Spider>();
  }

  @override
  void addEnemy({double xCoords = 500}) {
    if (state.enemies.length >= state.maxEnemies) return;

    final isLastSpider = state.enemies.length == state.maxEnemies - 1;

    final newSpider = Spider(
      xCoords: xCoords,
      damage: isLastSpider ? 3 : 1,
      currentLives: isLastSpider ? 10 : 5,
      maxLives: isLastSpider ? 10 : 5,
    );

    state = state.copyWith(
      enemies: [...state.enemies, newSpider],
    );

    startMoving();
  }

  @override
  void updateXCoords(double distance) {
    state = state.copyWith(
      enemies: state.enemies.map((spider) {
        final newPosition = spider.xCoords - distance;

        if (canMove()) return spider;

        if (!canMoveLeft(distance) || !canMoveRight(distance)) return spider;

        return spider.copyWith(
          xCoords: newPosition,
        );
      }).toList(),
    );
  }

  @override
  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  @override
  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  @override
  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  @override
  bool isPlayerColliding(double playerX, Spider enemy) {
    final leftBoundary = enemy.xCoords - (enemy.width / 2);
    final rightBoundary = enemy.xCoords + (enemy.width / 2);

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  @override
  void startMoving() {
    moveTimer?.cancel();
    moveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final playerState = ref.read(playerProvider);
      state = state.copyWith(
        enemies: state.enemies.map((spider) {
          if (spider.currentState == SpiderAnimation.walk) {
            return _moveSpiderTowardsPlayer(spider, playerState.xCoords);
          }
          return spider;
        }).toList(),
      );
    });
  }

  Spider _moveSpiderTowardsPlayer(Spider spider, double playerX) {
    final isPlayerNear = spider.xCoords < playerX + 50;

    return spider.copyWith(
      currentState:
          isPlayerNear ? SpiderAnimation.attack : spider.currentState,
      xCoords: isPlayerNear ? spider.xCoords : spider.xCoords - 5,
    );
  }

  @override
  void isAnyEnemyNear(double playerX) {
    state = state.copyWith(
      enemies: state.enemies.map(
        (spider) {
          if (!isPlayerColliding(playerX, spider)) return spider;

          return spider.copyWith(
            currentState: spider.currentState == SpiderAnimation.die
                ? SpiderAnimation.die
                : SpiderAnimation.walk,
            currentDirection: Directions.left,
          );
        },
      ).toList(),
    );
  }

  @override
  void takeDamage(double damage) {
    final backgroundPosition = ref.read(backgroundProvider).xCoords;
    state = state.copyWith(
      enemies: state.enemies.map((spider) {
        if (spider.currentState != SpiderAnimation.attack) return spider;

        final newHealth = spider.currentLives - damage;
        final spiderIndex = state.enemies.indexOf(spider);

        if (newHealth <= 0) {
          _handleSpiderDeath(spider, spiderIndex, backgroundPosition);
        }

        return spider.copyWith(
          currentLives: newHealth,
          currentState:
              newHealth <= 0 ? SpiderAnimation.die : SpiderAnimation.attack,
        );
      }).toList(),
    );
  }

  void _handleSpiderDeath(
      Spider spider, int spiderIndex, double backgroundPosition) {
    if (spiderIndex == state.maxEnemies - 1) {
      _handleLastSpiderDeath(spider, backgroundPosition);
    } else {
      _handleNonLastSpiderDeath(spider);
    }
  }

  void _handleLastSpiderDeath(Spider spider, double backgroundPosition) {
    Future.delayed(const Duration(seconds: 2), () {
      state = EnemyState<Spider>(); // Clear all spiders
      ref.read(chestProvider.notifier).addObject(
            xCoords: spider.xCoords + 50,
            coinValue: 5,
          );
      ref.read(doorProvider.notifier).addObject(
            xCoords: spider.xCoords + 150,
            doorType: DoorType.finish,
          );

      final playerX = ref.read(playerProvider).xCoords;
      ref.read(dogProvider.notifier).goBackToThePlayer(playerX);
      SnackbarService.show('¡Felicidades haz completado el primer nivel!',
          type: SnackbarType.animated);
    });

    final lastPosition = backgroundPosition + 300;
    ref.read(backgroundProvider.notifier).setRightLimit(lastPosition);
  }

  void _handleNonLastSpiderDeath(Spider spider) {
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(chestProvider.notifier).addObject(xCoords: spider.xCoords + 50);
      final playerX = ref.read(playerProvider).xCoords;
      ref.read(dogProvider.notifier).goBackToThePlayer(playerX);
      final random = Random();
      final randomDistance = random.nextDouble() * 1500 +
          900; // Random distance between 900 and 1500
      addEnemy(
        xCoords: spider.xCoords + randomDistance,
      );
    });
  }
}

final spiderProvider =
    StateNotifierProvider<SpiderNotifier, EnemyState<Spider>>((ref) {
  return SpiderNotifier(ref);
});