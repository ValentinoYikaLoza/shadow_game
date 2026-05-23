import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';

/// Contract for reading/writing the player's skill progress.
abstract class SkillsDatasource {
  Future<SkillsProgress> getProgress();
  Future<void> saveProgress(SkillsProgress progress);
}
