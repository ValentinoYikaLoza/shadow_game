import 'package:shadow_game/app/config/constants/storage_keys.dart';
import 'package:shadow_game/app/features/levels/domain/datasources/level_progress_datasource.dart';
import 'package:shadow_game/app/shared/services/error_service.dart';
import 'package:shadow_game/app/shared/services/storage_service.dart';

/// `SharedPreferences`-backed implementation of [LevelProgressDatasource].
class LevelProgressLocalDatasource implements LevelProgressDatasource {
  LevelProgressLocalDatasource(this._storage);

  final StorageService _storage;

  @override
  Future<int> getCurrentLevel() async {
    try {
      return _storage.getInt(StorageKeys.currentLevel) ?? 1;
    } catch (e) {
      throw ErrorService.toServiceException(
        e,
        fallback: 'No se pudo cargar el nivel actual',
      );
    }
  }

  @override
  Future<void> saveCurrentLevel(int level) async {
    try {
      await _storage.setInt(StorageKeys.currentLevel, level);
    } catch (e) {
      throw ErrorService.toServiceException(
        e,
        fallback: 'No se pudo guardar el nivel actual',
      );
    }
  }
}
