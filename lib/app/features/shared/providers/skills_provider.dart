import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/providers/player_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/snackbar.dart';

enum SkillType { damage, endurance, life, speed }

enum SkillLevels {
  // Damage Skills
  damageLevel1(SkillType.damage, 1, 'assets/images/shared/damage/damage_level1.png'),
  damageLevel2(SkillType.damage, 2, 'assets/images/shared/damage/damage_level2.png'),
  damageLevel3(SkillType.damage, 3, 'assets/images/shared/damage/damage_level3.png'),

  // Endurance Skills
  enduranceLevel1(SkillType.endurance, 1, 'assets/images/shared/endurance/endurance_level1.png'),
  enduranceLevel2(SkillType.endurance, 2, 'assets/images/shared/endurance/endurance_level2.png'),
  enduranceLevel3(SkillType.endurance, 3, 'assets/images/shared/endurance/endurance_level3.png'),

  // Life Skills
  lifeLevel1(SkillType.life, 1, 'assets/images/shared/life/life_level1.png'),
  lifeLevel2(SkillType.life, 2, 'assets/images/shared/life/life_level2.png'),
  lifeLevel3(SkillType.life, 3, 'assets/images/shared/life/life_level3.png'),

  // Speed Skills
  speedLevel1(SkillType.speed, 1, 'assets/images/shared/speed/speed_level1.png'),
  speedLevel2(SkillType.speed, 2, 'assets/images/shared/speed/speed_level2.png'),
  speedLevel3(SkillType.speed, 3, 'assets/images/shared/speed/speed_level3.png');

  final SkillType skillType;
  final double level;
  final String image;
  const SkillLevels(this.skillType, this.level, this.image);
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
      currentEnduranceImage: currentEnduranceImage ?? this.currentEnduranceImage,
      currentLifeImage: currentLifeImage ?? this.currentLifeImage,
      currentSpeedImage: currentSpeedImage ?? this.currentSpeedImage,
      currentLevelDamage: currentLevelDamage ?? this.currentLevelDamage,
      currentLevelEndurance: currentLevelEndurance ?? this.currentLevelEndurance,
      currentLevelLife: currentLevelLife ?? this.currentLevelLife,
      currentLevelSpeed: currentLevelSpeed ?? this.currentLevelSpeed,
    );
  }
}

class SkillNotifier extends StateNotifier<SkillState> {
  SkillNotifier(this.ref) : super(SkillState());
  final Ref ref;

  void levelUpSkill(SkillType skillType) {
    final playerState = ref.read(playerProvider);
    final currentLevel = _getCurrentLevel(skillType);
    final coinCost = _getCoinCost(currentLevel);

    if (playerState.coins >= coinCost) {
      _updateSkillLevel(skillType, currentLevel + 1, coinCost);
    } else {
      SnackbarService.show('No hay suficientes monedas');
    }
  }

  double _getCurrentLevel(SkillType skillType) {
    switch (skillType) {
      case SkillType.damage:
        return state.currentLevelDamage;
      case SkillType.endurance:
        return state.currentLevelEndurance;
      case SkillType.life:
        return state.currentLevelLife;
      case SkillType.speed:
        return state.currentLevelSpeed;
    }
  }

  double _getCoinCost(double currentLevel) {
    return currentLevel == 1 ? 1 : 5;
  }

  void _updateSkillLevel(SkillType skillType, double newLevel, double coinCost) {
    final playerNotifier = ref.read(playerProvider.notifier);
    playerNotifier.addCoins(-coinCost);

    switch (skillType) {
      case SkillType.damage:
        state = state.copyWith(
          currentLevelDamage: newLevel,
          currentDamageImage: _getSkillGif(skillType, newLevel),
        );
        playerNotifier.updateDamage(newLevel == 2 ? 2 : 2);
        break;
      case SkillType.endurance:
        state = state.copyWith(
          currentLevelEndurance: newLevel,
          currentEnduranceImage: _getSkillGif(skillType, newLevel),
        );
        playerNotifier.updateDamageResistance(newLevel == 2 ? 0.3 : 0.5);
        break;
      case SkillType.life:
        state = state.copyWith(
          currentLevelLife: newLevel,
          currentLifeImage: _getSkillGif(skillType, newLevel),
        );
        playerNotifier.updateMaxLives(newLevel == 2 ? 11 : 12);
        break;
      case SkillType.speed:
        state = state.copyWith(
          currentLevelSpeed: newLevel,
          currentSpeedImage: _getSkillGif(skillType, newLevel),
        );
        playerNotifier.updateSpeed(newLevel == 2 ? 0.5 : 0.8);
        break;
    }
  }

  SkillLevels _getSkillGif(SkillType skillType, double level) {
    return SkillLevels.values.firstWhere(
      (skillLevel) => skillLevel.skillType == skillType && skillLevel.level == level,
    );
  }
}

final skillProvider = StateNotifierProvider<SkillNotifier, SkillState>((ref) {
  return SkillNotifier(ref);
});
