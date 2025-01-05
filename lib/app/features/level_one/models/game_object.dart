import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

abstract class GameObject {
  final double xCoords;
  final double width;

  GameObject({required this.xCoords, required this.width});

  GameObject copyWith({double? xCoords, double? width});
}

mixin CollisionMixin<T> on StateNotifier<T> {
  Ref get ref;

  bool isPlayerColliding(double playerX, GameObject object) {
    final leftBoundary = object.xCoords;
    final rightBoundary = object.xCoords + object.width;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    return playerRightBoundary >= leftBoundary && playerLeftBoundary <= rightBoundary;
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
}