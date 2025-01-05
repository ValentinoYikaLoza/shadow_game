import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/dog_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/snackbar.dart';

class SpiderState {
  final List<Spider> spiders;
  final int maxSpiders;

  SpiderState({
    this.spiders = const [],
    this.maxSpiders = 5,
  });

  SpiderState copyWith({
    List<Spider>? spiders,
    int? maxSpiders,
  }) {
    return SpiderState(
      spiders: spiders ?? this.spiders,
      maxSpiders: maxSpiders ?? this.maxSpiders,
    );
  }
}

class Spider {
  final double xCoords;
  final SpiderAnimations currentState;
  final Directions currentDirection;
  final double width;
  final double currentLives;
  final double maxLives;
  final double damage;

  Spider({
    this.xCoords = 500,
    this.currentState = SpiderAnimations.stay,
    this.currentDirection = Directions.left,
    this.width = 300,
    this.currentLives = 5,
    this.maxLives = 5,
    this.damage = 1,
  });

  Spider copyWith({
    double? xCoords,
    SpiderAnimations? currentState,
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

class SpiderNotifier extends StateNotifier<SpiderState> {
  SpiderNotifier(this.ref) : super(SpiderState());

  final Ref ref;
  Timer? moveTimer;
  Timer? disapearTimer;

  /// Restablece el estado de las arañas
  void resetData(bool isTutorialMode) {
    state = isTutorialMode ? SpiderState(maxSpiders: 1) : SpiderState();
  }

  void addSpider({double xCoords = 500}) {
    if (state.spiders.length >= state.maxSpiders) return;

    final isLastSpider = state.spiders.length == state.maxSpiders - 1;

    final newSpider = Spider(
      xCoords: xCoords,
      damage: isLastSpider ? 3 : 1,
      currentLives: isLastSpider ? 10 : 5,
      maxLives: isLastSpider ? 10 : 5,
    );

    state = state.copyWith(
      spiders: [...state.spiders, newSpider],
    );

    startMoving();
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        spiders: state.spiders.map((spider) {
      final newPosition = spider.xCoords - distance;

      if (canMove()) return spider;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return spider;

      return spider.copyWith(
        xCoords: newPosition,
      );
    }).toList());
  }

  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  bool isPlayerColliding(double playerX, Spider spider) {
    final leftBoundary = spider.xCoords - (spider.width / 2);
    final rightBoundary = spider.xCoords + (spider.width / 2);

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  void startMoving() {
    moveTimer?.cancel();
    moveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final playerState = ref.read(playerProvider);
      state = state.copyWith(
        spiders: state.spiders.map((spider) {
          if (spider.currentState == SpiderAnimations.walk) {
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
          isPlayerNear ? SpiderAnimations.attack : spider.currentState,
      xCoords: isPlayerNear ? spider.xCoords : spider.xCoords - 5,
    );
  }

  void isAnySpiderNear(double playerX) {
    state = state.copyWith(
      spiders: state.spiders.map(
        (spider) {
          if (!isPlayerColliding(playerX, spider)) return spider;

          return spider.copyWith(
            currentState: spider.currentState == SpiderAnimations.die
                ? SpiderAnimations.die
                : SpiderAnimations.walk,
            currentDirection: Directions.left,
          );
        },
      ).toList(),
    );
  }

  void takeDamage(double damage) {
    final backgroundPosition = ref.read(backgroundProvider).xCoords;
    state = state.copyWith(
      spiders: state.spiders.map((spider) {
        if (spider.currentState != SpiderAnimations.attack) return spider;

        final newHealth = spider.currentLives - damage;
        final spiderIndex = state.spiders.indexOf(spider);

        if (newHealth <= 0) {
          _handleSpiderDeath(spider, spiderIndex, backgroundPosition);
        }

        return spider.copyWith(
          currentLives: newHealth,
          currentState:
              newHealth <= 0 ? SpiderAnimations.die : SpiderAnimations.attack,
        );
      }).toList(),
    );
  }

  void _handleSpiderDeath(
      Spider spider, int spiderIndex, double backgroundPosition) {
    if (spiderIndex == state.maxSpiders - 1) {
      _handleLastSpiderDeath(spider, backgroundPosition);
    } else {
      _handleNonLastSpiderDeath(spider);
    }
  }

  void _handleLastSpiderDeath(Spider spider, double backgroundPosition) {
    Future.delayed(const Duration(seconds: 2), () {
      state = SpiderState(); // Clear all spiders
      ref.read(chestProvider.notifier).addChest(
            xCoords: spider.xCoords + 50,
            coinValue: 5,
          );
      ref.read(doorProvider.notifier).addDoor(
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
      ref.read(chestProvider.notifier).addChest(xCoords: spider.xCoords + 50);
      final playerX = ref.read(playerProvider).xCoords;
      ref.read(dogProvider.notifier).goBackToThePlayer(playerX);
      final random = Random();
      final randomDistance = random.nextDouble() * 1500 +
          900; // Random distance between 900 and 1500
      addSpider(
        xCoords: spider.xCoords + randomDistance,
      );
    });
  }
}

final spiderProvider =
    StateNotifierProvider<SpiderNotifier, SpiderState>((ref) {
  return SpiderNotifier(ref);
});
