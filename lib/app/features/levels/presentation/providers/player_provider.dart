import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/levels/domain/entities/animations.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/background_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/chest_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/coin_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/dog_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/door_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/spider_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/routes/levels_routes.dart';
import 'package:shadow_game/app/features/lobby/presentation/routes/lobby_routes.dart';

enum PlayerStatus { playing, tutorial, gameOver }

class PlayerState {
  final double xCoords;
  final double yCoords;
  final double currentLives;
  final double maxLives;
  final double damage;
  final double damageResistance;
  final double coins;
  final double speed;
  final PlayerStatus currentStatus;
  final PlayerAnimation currentAnimation;
  final Directions currentDirection;
  final bool isBetweenTheLimits;
  final bool isJumping;

  PlayerState({
    required this.maxLives,
    required this.currentLives,
    required this.currentStatus,
    this.currentAnimation = PlayerAnimation.stay,
    this.currentDirection = Directions.right,
    this.xCoords = 20.0,
    this.yCoords = 0.0,
    this.damage = 1,
    this.damageResistance = 0.1,
    this.coins = 0,
    this.speed = 0.2,
    this.isBetweenTheLimits = false,
    this.isJumping = false,
  });

  PlayerState copyWith({
    double? maxLives,
    double? xCoords,
    double? yCoords,
    double? currentLives,
    double? damage,
    double? damageResistance,
    double? coins,
    double? speed,
    PlayerStatus? currentStatus,
    PlayerAnimation? currentAnimation,
    Directions? currentDirection,
    bool? isBetweenTheLimits,
    bool? isJumping,
  }) {
    return PlayerState(
      maxLives: maxLives ?? this.maxLives,
      xCoords: xCoords ?? this.xCoords,
      yCoords: yCoords ?? this.yCoords,
      currentLives: currentLives ?? this.currentLives,
      damage: damage ?? this.damage,
      damageResistance: damageResistance ?? this.damageResistance,
      coins: coins ?? this.coins,
      speed: speed ?? this.speed,
      currentStatus: currentStatus ?? this.currentStatus,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      currentDirection: currentDirection ?? this.currentDirection,
      isBetweenTheLimits: isBetweenTheLimits ?? this.isBetweenTheLimits,
      isJumping: isJumping ?? this.isJumping,
    );
  }
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref)
      : super(PlayerState(
            maxLives: 10,
            currentLives: 10,
            currentStatus: PlayerStatus.playing));

  final Ref ref;

  Timer? _jumpTimer;
  Timer? _fallTimer;
  Timer? _inactivityTimer;

  static const inactivityDuration = Duration(seconds: 5);
  static const leftLimit = 20.0;
  static const deltaX = 10.0;

  @override
  void dispose() {
    _jumpTimer?.cancel();
    _fallTimer?.cancel();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void resetData() {
    final isTutorial = state.currentStatus == PlayerStatus.tutorial;
    state = PlayerState(
        maxLives: 10, currentLives: 10, currentStatus: PlayerStatus.playing);
    ref.read(doorProvider.notifier).resetData();
    ref.read(coinProvider.notifier).resetData();
    ref.read(chestProvider.notifier).resetData();
    ref.read(spiderProvider.notifier).resetData(isTutorial);
    ref.read(backgroundProvider.notifier).resetData();
    ref.read(dogProvider.notifier).resetData();
  }

  void startInactivityTimer() {
    stopInactivityTimer();
    _inactivityTimer = Timer(inactivityDuration, () {
      if (!mounted) return;
      dance();
    });
  }

  void goToNextLevel() {
    AppRouter.go(LevelsRoutes.levelTwo.path);
  }

  void stopInactivityTimer() {
    _inactivityTimer?.cancel();
  }

  void resetInactivityTimer() {
    startInactivityTimer();
  }

  void updateLives(double newLives) {
    state = state.copyWith(currentLives: newLives);
  }

  void updateMaxLives(double newMaxLives) {
    if (state.maxLives == state.currentLives) {
      updateLives(newMaxLives);
    }
    state = state.copyWith(maxLives: newMaxLives);
  }

  void updateCoins(double newCoins) {
    state = state.copyWith(coins: newCoins);
  }

  void updateSpeed(double newSpeed) {
    state = state.copyWith(speed: newSpeed);
  }

  void updateDamage(double newDamage) {
    state = state.copyWith(damage: newDamage);
  }

  void updateDamageResistance(double newDamageResistance) {
    state = state.copyWith(damageResistance: newDamageResistance);
  }

  void updateCoords(double xCoords, double yCoords) {
    if (!state.isBetweenTheLimits) return;

    state = state.copyWith(xCoords: xCoords, yCoords: yCoords);
  }

  void updateStatus(PlayerStatus newStatus) {
    state = state.copyWith(currentStatus: newStatus);
  }

  void updateAnimation(PlayerAnimation newAnimation) {
    state = state.copyWith(currentAnimation: newAnimation);
  }

  void updateDirection(Directions newDirection) {
    state = state.copyWith(currentDirection: newDirection);
  }

  void updateFlagIsBetweenTheLimits(bool isBetweenTheLimits) {
    state = state.copyWith(isBetweenTheLimits: isBetweenTheLimits);
  }

  void updateFlagIsJumping(bool isJumping) {
    state = state.copyWith(isJumping: isJumping);
  }

  void tutorialMode() {
    resetData();
    updateStatus(PlayerStatus.tutorial);
  }

  void gameOver() {
    updateStatus(PlayerStatus.gameOver);
    AppRouter.go(LobbyRoutes.gameOver.path);
  }

  void takeDamage(double damage) {
    if (state.currentStatus == PlayerStatus.tutorial) return;
    final random = Random();
    if (random.nextDouble() > state.damageResistance) {
      final newLives = state.currentLives - damage;
      updateLives(newLives);
      if (newLives <= 0) {
        gameOver();
      }
    }
  }

  void addCoins(double coins) {
    final newCoins = state.coins + coins;
    updateCoins(newCoins);
  }

  void attack() {
    resetInactivityTimer();
    updateAnimation(PlayerAnimation.attack);
    ref
        .read(spiderProvider.notifier)
        .takeDamage(state.damage);
  }

  void jump() {
    resetInactivityTimer();
    if (state.isJumping) return;

    state = state.copyWith(
      isJumping: true,
      currentAnimation: PlayerAnimation.jump,
    );

    _jumpTimer?.cancel();
    _jumpTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (state.yCoords <= 25) {
        updateCoords(state.xCoords, state.yCoords + 5);
      } else {
        timer.cancel();
        _startFalling();
      }
    });
  }

  void _startFalling() {
    resetInactivityTimer();
    _fallTimer?.cancel();
    _fallTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (state.yCoords >= 5) {
        updateCoords(state.xCoords, state.yCoords - 5);
      } else {
        timer.cancel();
        _land();
      }
    });
  }

  void _land() {
    resetInactivityTimer();
    state = state.copyWith(
      isJumping: false,
      currentAnimation: PlayerAnimation.stay,
    );
  }

  void dance() {
    updateAnimation(PlayerAnimation.dance);
  }

  void move() {
    resetInactivityTimer();
    ref.read(dogProvider.notifier).followPlayer(state.xCoords);
    updateAnimation(PlayerAnimation.walk);
  }

  void stopMovement() {
    resetInactivityTimer();
    updateAnimation(PlayerAnimation.stay);
  }

  void moveLeft() {
    final distance = -deltaX * state.speed;

    state.xCoords > leftLimit
        ? updateFlagIsBetweenTheLimits(true)
        : updateFlagIsBetweenTheLimits(false);

    final newPosition = state.xCoords + distance;

    updateDirection(Directions.left);
    updateEnvironmentEntitiesCoords(distance);
    checkCollisions();
    updateCoords(newPosition, state.yCoords);
    move();
  }

  void moveRight(double rightLimit) {
    final distance = deltaX * state.speed;

    state.xCoords < rightLimit
        ? updateFlagIsBetweenTheLimits(true)
        : updateFlagIsBetweenTheLimits(false);

    final newPosition = state.xCoords + distance;

    updateCoords(newPosition, state.yCoords);
    updateEnvironmentEntitiesCoords(distance);
    checkCollisions();
    updateDirection(Directions.right);
    move();
  }

  void updateEnvironmentEntitiesCoords(double distance) {
    if (state.currentStatus == PlayerStatus.tutorial) return;
    ref.read(doorProvider.notifier).updateXCoords(distance);
    ref.read(coinProvider.notifier).updateXCoords(distance);
    ref.read(chestProvider.notifier).updateXCoords(distance);
    ref
        .read(spiderProvider.notifier)
        .updateXCoords(distance);
    ref.read(backgroundProvider.notifier).updateXCoords(distance);
  }

  void checkCollisions() {
    checkCollisionsDoors();
    checkCollisionsCoins();
    checkCollisionsChests();
    checkCollisionsSpiders();
  }

  void checkCollisionsDoors() {
    ref.read(doorProvider.notifier).isAnyObjectNear(state.xCoords);
  }

  void checkCollisionsCoins() {
    ref.read(coinProvider.notifier).isAnyObjectNear(state.xCoords);
  }

  void checkCollisionsChests() {
    ref.read(chestProvider.notifier).isAnyObjectNear(state.xCoords);
  }

  void checkCollisionsSpiders() {
    ref
        .read(spiderProvider.notifier)
        .isAnyEnemyNear(state.xCoords);

    final spiders = ref.read(spiderProvider).enemies;
    final isSpiderNear = spiders.any((spider) =>
        spider.currentAnimation == SpiderAnimation.walk ||
        spider.currentAnimation == SpiderAnimation.attack);

    _updatePlayerSpeed(isSpiderNear);
    _updateDogBehavior(isSpiderNear);
  }

  void _updatePlayerSpeed(bool isSpiderNear) {
    final double newSpeed = isSpiderNear ? 0 : 0.2;
    state = state.copyWith(speed: newSpeed);
  }

  void _updateDogBehavior(bool isSpiderNear) {
    ref.read(dogProvider.notifier).goAwayFromEnemy(state.xCoords, isSpiderNear);
  }
}

final playerProvider =
    StateNotifierProvider.autoDispose<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});
