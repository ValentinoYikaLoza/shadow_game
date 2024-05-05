import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref) : super(PlayerState());
  final StateNotifierProviderRef ref;

  getHurt(int damage) {
    int life = state.life;

    if (state.endurance == 0){
      life -= damage;
    }else{
      life -= (damage / Random().nextInt(state.endurance)).round();
    }

    state = state.copyWith(
      life: life,
    );
  }
  walk(bool walk){
    state = state.copyWith(
      isWalking: walk,
      isAttacking: !walk,
      isDancing: !walk,
      isJumping: !walk,
      isStaying: !walk,
    );
  }
  dance(bool dance){
    state = state.copyWith(
      isDancing: dance,
      isAttacking: !dance,
      isJumping: !dance,
      isStaying: !dance,
      isWalking: !dance,
    );
  }
  attack(bool attack){
    state = state.copyWith(
      isAttacking: attack,
      isDancing: !attack,
      isJumping: !attack,
      isStaying: !attack,
      isWalking: !attack,
    );
  }
  jump(bool jump){
    state = state.copyWith(
      isJumping: jump,
      isAttacking: !jump,
      isDancing: !jump,
      isStaying: !jump,
      isWalking: !jump,
    );
  }
  stay(bool stay){
    state = state.copyWith(
      isStaying: stay,
      isJumping: !stay,
      isAttacking: !stay,
      isDancing: !stay,
      isWalking: !stay,
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
