import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';

/// Contract the presentation layer depends on to load/persist skill progress.
abstract class SkillsRepository {
  Future<SkillsProgress> getProgress();
  Future<void> saveProgress(SkillsProgress progress);
}
