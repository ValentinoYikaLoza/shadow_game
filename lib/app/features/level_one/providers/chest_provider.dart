import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/data.dart';
import 'package:shadow_game/app/features/level_one/models/game_object.dart';
import 'package:shadow_game/app/features/level_one/providers/coin_provider.dart';

class Chest extends GameObject {
  final ChestSprites currentState;
  final bool hasCoin;
  final double coinValue;

  Chest({
    super.xCoords = 600,
    super.width = 60,
    this.currentState = ChestSprites.close,
    this.hasCoin = false,
    this.coinValue = 1,
  });

  @override
  Chest copyWith({
    double? xCoords,
    ChestSprites? currentState,
    bool? hasCoin,
    double? coinValue,
    double? width,
  }) {
    return Chest(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      hasCoin: hasCoin ?? this.hasCoin,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

class ChestNotifier extends StateNotifier<ChestState>
    with CollisionMixin<ChestState> {
  ChestNotifier(this.ref) : super(ChestState());

  @override
  final Ref ref;

  void resetData() {
    state = ChestState();
  }

  void addChest({double xCoords = 600, double coinValue = 1}) {
    state = state.copyWith(
      chests: [...state.chests, Chest(xCoords: xCoords, coinValue: coinValue)],
    );
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        chests: state.chests.map((chest) {
      final newPosition = chest.xCoords - distance;

      if (canMove()) return chest;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return chest;

      return chest.copyWith(xCoords: newPosition);
    }).toList());
  }

  void isAnyChestNear(double playerX) {
    state = state.copyWith(
      chests: state.chests.map((chest) {
        if (!isPlayerColliding(playerX, chest)) return chest;

        if (chest.currentState == ChestSprites.open && !chest.hasCoin) {
          _dropCoin(chest);
          return chest.copyWith(hasCoin: true);
        }

        return chest.copyWith(currentState: ChestSprites.open);
      }).toList(),
    );
  }

  void _dropCoin(Chest chest) {
    ref.read(coinProvider.notifier).addCoin(
          initialPosition: chest.xCoords + 50,
          coinValue: chest.coinValue,
        );
  }
}

class ChestState {
  final List<Chest> chests;

  ChestState({this.chests = const []});

  ChestState copyWith({List<Chest>? chests}) {
    return ChestState(chests: chests ?? this.chests);
  }
}

final chestProvider = StateNotifierProvider<ChestNotifier, ChestState>((ref) {
  return ChestNotifier(ref);
});
