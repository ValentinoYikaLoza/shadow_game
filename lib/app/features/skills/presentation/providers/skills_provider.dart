import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/player_provider.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/features/skills/domain/repositories/skills_repository.dart';
import 'package:shadow_game/app/shared/models/service_exception.dart';
import 'package:shadow_game/app/shared/widgets/snackbar.dart';
import 'package:shadow_game/di.dart';

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

class SkillNotifier extends StateNotifier<SkillState> {
  SkillNotifier(this.ref) : super(SkillState()) {
    _load();
  }
  final Ref ref;

  final SkillsRepository _repo = getIt<SkillsRepository>();

  static const _maxLevel = 3;

  /// Restores the persisted skill levels (and their icons) on boot, so the
  /// skills dialog shows the right levels/costs across app restarts.
  Future<void> _load() async {
    try {
      final progress = await _repo.getProgress();
      state = state.copyWith(
        currentLevelDamage: progress.damageLevel.toDouble(),
        currentLevelEndurance: progress.enduranceLevel.toDouble(),
        currentLevelLife: progress.lifeLevel.toDouble(),
        currentLevelSpeed: progress.speedLevel.toDouble(),
        currentDamageImage:
            _getSkillGif(SkillType.damage, progress.damageLevel.toDouble()),
        currentEnduranceImage: _getSkillGif(
            SkillType.endurance, progress.enduranceLevel.toDouble()),
        currentLifeImage:
            _getSkillGif(SkillType.life, progress.lifeLevel.toDouble()),
        currentSpeedImage:
            _getSkillGif(SkillType.speed, progress.speedLevel.toDouble()),
      );
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    } catch (_) {
      // Keep default levels if anything goes wrong.
    }
  }

  Future<void> _save() async {
    try {
      await _repo.saveProgress(
        SkillsProgress(
          damageLevel: state.currentLevelDamage.toInt(),
          enduranceLevel: state.currentLevelEndurance.toInt(),
          lifeLevel: state.currentLevelLife.toInt(),
          speedLevel: state.currentLevelSpeed.toInt(),
        ),
      );
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    } catch (_) {
      // Persistence is best-effort; never break the gameplay loop for it.
    }
  }

  void levelUpSkill(SkillType skillType) {
    final playerState = ref.read(playerProvider);
    final currentLevel = _getCurrentLevel(skillType);

    if (currentLevel >= _maxLevel) {
      SnackbarService.show('Habilidad al nivel máximo');
      return;
    }

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

    _save();
  }

  SkillLevels _getSkillGif(SkillType skillType, double level) {
    return SkillLevels.values.firstWhere(
      (skillLevel) =>
          skillLevel.skillType == skillType && skillLevel.level == level,
    );
  }
}

final skillProvider = StateNotifierProvider<SkillNotifier, SkillState>((ref) {
  return SkillNotifier(ref);
});
