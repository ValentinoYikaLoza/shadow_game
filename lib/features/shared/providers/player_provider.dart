import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref) : super(PlayerState());
  final StateNotifierProviderRef ref;

  getHurt() {
    int life = state.life;

    // Calcula la probabilidad de recibir daño basada en la resistencia
    double enduranceEffect = (1 - (state.endurance / 100));
    bool receiveDamage = Random().nextDouble() < enduranceEffect;

    if (receiveDamage) {
      life -= 1;
    }

    state = state.copyWith(
      life: life,
    );
  }
  walk(bool walk){
    state = state.copyWith(
      isWalking: walk,
    );
  }
  dance(bool dance){
    state = state.copyWith(
      isDancing: dance,
    );
  }
  attack(bool attack){
    state = state.copyWith(
      isAttacking: attack,
    );
  }
  jump(bool jump){
    state = state.copyWith(
      isJumping: jump,
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
  PlayerState({
    this.life = 10,
    this.damage = 1,
    this.endurance = 0,
    this.speed = 1,
    this.isWalking = false,
    this.isDancing = false,
    this.isAttacking = false,
    this.isJumping = false,
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
    );
  }
}
