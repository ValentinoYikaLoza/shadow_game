import 'package:shadow_game/app/features/skills/domain/datasources/skills_datasource.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/features/skills/domain/repositories/skills_repository.dart';

/// Delegates to the local datasource. Kept as a separate layer so a remote/
/// cloud-save source could later be orchestrated here without touching the UI.
class SkillsRepositoryImpl implements SkillsRepository {
  SkillsRepositoryImpl(this._datasource);

  final SkillsDatasource _datasource;

  @override
  Future<SkillsProgress> getProgress() => _datasource.getProgress();

  @override
  Future<void> saveProgress(SkillsProgress progress) =>
      _datasource.saveProgress(progress);
}
