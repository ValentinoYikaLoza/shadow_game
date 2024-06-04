import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlayerAction { walking, dancing, attacking, jumping, staying }

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref) : super(PlayerState());
  final StateNotifierProviderRef ref;

  void getHurt(int damage) {
    int life = state.life;
    int endurance = state.endurance;

    if (endurance == 0) {
      life -= damage;
    } else {
      life -= (damage / Random().nextInt(endurance + 1)).round(); // Avoid division by zero
    }

    state = state.copyWith(life: life);
  }

  void setAction(PlayerAction action) {
    state = state.copyWith(
      isWalking: action == PlayerAction.walking,
      isDancing: action == PlayerAction.dancing,
      isAttacking: action == PlayerAction.attacking,
      isJumping: action == PlayerAction.jumping,
      isStaying: action == PlayerAction.staying,
    );
  }
}


class PlayerState {
  final int life;
  final int damage;
  final int endurance;
  final int speed;
  final bool isWalking;
  final bool isDancing;
  final bool isAttacking;
  final bool isJumping;
  final bool isStaying;

  PlayerState({
    this.life = 10,
    this.damage = 1,
    this.endurance = 0,
    this.speed = 1,
    this.isWalking = false,
    this.isDancing = false,
    this.isAttacking = false,
    this.isJumping = false,
    this.isStaying = false,
  });

  PlayerState copyWith({
    int? life,
    int? damage,
    int? endurance,
    int? speed,
    bool? isWalking,
    bool? isDancing,
    bool? isAttacking,
    bool? isJumping,
    bool? isStaying,
  }) {
    return PlayerState(
      life: life ?? this.life,
      damage: damage ?? this.damage,
      endurance: endurance ?? this.endurance,
      speed: speed ?? this.speed,
      isWalking: isWalking ?? this.isWalking,
      isDancing: isDancing ?? this.isDancing,
      isAttacking: isAttacking ?? this.isAttacking,
      isJumping: isJumping ?? this.isJumping,
      isStaying: isStaying ?? this.isStaying,
    );
  }
}
