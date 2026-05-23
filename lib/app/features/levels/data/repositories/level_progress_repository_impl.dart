import 'package:shadow_game/app/features/levels/domain/datasources/level_progress_datasource.dart';
import 'package:shadow_game/app/features/levels/domain/repositories/level_progress_repository.dart';

class LevelProgressRepositoryImpl implements LevelProgressRepository {
  LevelProgressRepositoryImpl(this._datasource);

  final LevelProgressDatasource _datasource;

  @override
  Future<int> getCurrentLevel() => _datasource.getCurrentLevel();

  @override
  Future<void> saveCurrentLevel(int level) =>
      _datasource.saveCurrentLevel(level);
}
