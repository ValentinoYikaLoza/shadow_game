import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/snackbar.dart'; // Importing player provider to access coins

final skillProvider = StateNotifierProvider<SkillNotifier, SkillState>((ref) {
  return SkillNotifier(ref);
});

class SkillNotifier extends StateNotifier<SkillState> {
  SkillNotifier(this.ref) : super(SkillState());
  final Ref ref;

  void levelUPDamage() {
    final playerState = ref.read(playerProvider);

    // Check coin requirements for each level
    if (state.currentLevelDamage == 1 && playerState.coins >= 1) {
      _updateDamageLevel(2, 1);
      ref.read(playerProvider.notifier).updateDamage(2);
    } else if (state.currentLevelDamage == 2 && playerState.coins >= 5) {
      _updateDamageLevel(3, 5);
      ref.read(playerProvider.notifier).updateDamage(2);
    } else {
      SnackbarService.show('No hay suficientes monedas');
      return;
    }
  }

  void levelUPEndurance() {
    final playerState = ref.read(playerProvider);

    // Check coin requirements for each level
    if (state.currentLevelEndurance == 1 && playerState.coins >= 1) {
      _updateEnduranceLevel(2, 1);
      ref.read(playerProvider.notifier).updateDamageResistance(0.3);
    } else if (state.currentLevelEndurance == 2 && playerState.coins >= 5) {
      _updateEnduranceLevel(3, 5);
      ref.read(playerProvider.notifier).updateDamageResistance(0.5);
    } else {
      SnackbarService.show('No hay suficientes monedas');
      return;
    }
  }

  void levelUPLife() {
    final playerState = ref.read(playerProvider);

    // Check coin requirements for each level
    if (state.currentLevelLife == 1 && playerState.coins >= 1) {
      _updateLifeLevel(2, 1);
      ref.read(playerProvider.notifier).updateMaxLives(11);
    } else if (state.currentLevelLife == 2 && playerState.coins >= 5) {
      _updateLifeLevel(3, 5);
      ref.read(playerProvider.notifier).updateMaxLives(12);
    } else {
      SnackbarService.show('No hay suficientes monedas');
      return;
    }
  }

  void levelUPSpeed() {
    final playerState = ref.read(playerProvider);

    // Check coin requirements for each level
    if (state.currentLevelSpeed == 1 && playerState.coins >= 1) {
      _updateSpeedLevel(2, 1);
      ref.read(playerProvider.notifier).updateSpeed(0.5);
    } else if (state.currentLevelSpeed == 2 && playerState.coins >= 5) {
      _updateSpeedLevel(3, 5);
      ref.read(playerProvider.notifier).updateSpeed(0.8);
    } else {
      SnackbarService.show('No hay suficientes monedas');
      return;
    }
  }

  void _updateDamageLevel(double newLevel, double coinCost) {
    final playerNotifier = ref.read(playerProvider.notifier);
    playerNotifier.addCoins(-coinCost); // Deduct coins

    state = state.copyWith(
      currentLevelDamage: newLevel,
      currentDamageImage: _getSkillGif('damage', newLevel),
    );
  }

  void _updateEnduranceLevel(double newLevel, double coinCost) {
    final playerNotifier = ref.read(playerProvider.notifier);
    playerNotifier.addCoins(-coinCost); // Deduct coins

    state = state.copyWith(
      currentLevelEndurance: newLevel,
      currentEnduranceImage: _getSkillGif('endurance', newLevel),
    );
  }

  void _updateLifeLevel(double newLevel, double coinCost) {
    final playerNotifier = ref.read(playerProvider.notifier);
    playerNotifier.addCoins(-coinCost); // Deduct coins

    state = state.copyWith(
      currentLevelLife: newLevel,
      currentLifeImage: _getSkillGif('life', newLevel),
    );
  }

  void _updateSpeedLevel(double newLevel, double coinCost) {
    final playerNotifier = ref.read(playerProvider.notifier);
    playerNotifier.addCoins(-coinCost); // Deduct coins

    state = state.copyWith(
      currentLevelSpeed: newLevel,
      currentSpeedImage: _getSkillGif('speed', newLevel),
    );
  }

  SkillLevels _getSkillGif(String skillType, double level) {
    switch (skillType) {
      case 'damage':
        return level == 1
            ? SkillLevels.damageLevel1
            : level == 2
                ? SkillLevels.damageLevel2
                : SkillLevels.damageLevel3;
      case 'endurance':
        return level == 1
            ? SkillLevels.enduranceLevel1
            : level == 2
                ? SkillLevels.enduranceLevel2
                : SkillLevels.enduranceLevel3;
      case 'life':
        return level == 1
            ? SkillLevels.lifeLevel1
            : level == 2
                ? SkillLevels.lifeLevel2
                : SkillLevels.lifeLevel3;
      case 'speed':
        return level == 1
            ? SkillLevels.speedLevel1
            : level == 2
                ? SkillLevels.speedLevel2
                : SkillLevels.speedLevel3;
      default:
        return SkillLevels.damageLevel1;
    }
  }
}

class SkillState {
  final double currentLevelDamage;
  final double currentLevelEndurance;
  final double currentLevelLife;
  final double currentLevelSpeed;
  final SkillLevels currentDamageImage;
  final SkillLevels currentEnduranceImage;
  final SkillLevels currentLifeImage;
  final SkillLevels currentSpeedImage;

  SkillState({
    this.currentDamageImage = SkillLevels.damageLevel1,
    this.currentEnduranceImage = SkillLevels.enduranceLevel1,
    this.currentLifeImage = SkillLevels.lifeLevel1,
    this.currentSpeedImage = SkillLevels.speedLevel1,
    this.currentLevelDamage = 1,
    this.currentLevelEndurance = 1,
    this.currentLevelLife = 1,
    this.currentLevelSpeed = 1,
  });

  SkillState copyWith({
    double? currentLevelDamage,
    double? currentLevelEndurance,
    double? currentLevelLife,
    double? currentLevelSpeed,
    SkillLevels? currentDamageImage,
    SkillLevels? currentEnduranceImage,
    SkillLevels? currentLifeImage,
    SkillLevels? currentSpeedImage,
  }) {
    return SkillState(
      currentDamageImage: currentDamageImage ?? this.currentDamageImage,
      currentEnduranceImage:
          currentEnduranceImage ?? this.currentEnduranceImage,
      currentLifeImage: currentLifeImage ?? this.currentLifeImage,
      currentSpeedImage: currentSpeedImage ?? this.currentSpeedImage,
      currentLevelDamage: currentLevelDamage ?? this.currentLevelDamage,
      currentLevelEndurance:
          currentLevelEndurance ?? this.currentLevelEndurance,
      currentLevelLife: currentLevelLife ?? this.currentLevelLife,
      currentLevelSpeed: currentLevelSpeed ?? this.currentLevelSpeed,
    );
  }
}

enum SkillLevels {
  // Damage Skills
  damageLevel1('assets/images/shared/damage/damage_level1.png'),
  damageLevel2('assets/images/shared/damage/damage_level2.png'),
  damageLevel3('assets/images/shared/damage/damage_level3.png'),

  // Endurance Skills
  enduranceLevel1('assets/images/shared/endurance/endurance_level1.png'),
  enduranceLevel2('assets/images/shared/endurance/endurance_level2.png'),
  enduranceLevel3('assets/images/shared/endurance/endurance_level3.png'),

  // Life Skills
  lifeLevel1('assets/images/shared/life/life_level1.png'),
  lifeLevel2('assets/images/shared/life/life_level2.png'),
  lifeLevel3('assets/images/shared/life/life_level3.png'),

  // Speed Skills
  speedLevel1('assets/images/shared/speed/speed_level1.png'),
  speedLevel2('assets/images/shared/speed/speed_level2.png'),
  speedLevel3('assets/images/shared/speed/speed_level3.png');

  final String image;
  const SkillLevels(this.image);
}
