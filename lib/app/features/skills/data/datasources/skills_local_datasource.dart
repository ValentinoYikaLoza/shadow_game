import 'package:shadow_game/app/config/constants/storage_keys.dart';
import 'package:shadow_game/app/features/skills/domain/datasources/skills_datasource.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/shared/services/error_service.dart';
import 'package:shadow_game/app/shared/services/storage_service.dart';

/// `SharedPreferences`-backed implementation of [SkillsDatasource].
class SkillsLocalDatasource implements SkillsDatasource {
  SkillsLocalDatasource(this._storage);

  final StorageService _storage;

  @override
  Future<SkillsProgress> getProgress() async {
    try {
      return SkillsProgress(
        damageLevel: _storage.getInt(StorageKeys.skillDamageLevel) ?? 1,
        enduranceLevel: _storage.getInt(StorageKeys.skillEnduranceLevel) ?? 1,
        lifeLevel: _storage.getInt(StorageKeys.skillLifeLevel) ?? 1,
        speedLevel: _storage.getInt(StorageKeys.skillSpeedLevel) ?? 1,
      );
    } catch (e) {
      throw ErrorService.toServiceException(
        e,
        fallback: 'No se pudo cargar el progreso de habilidades',
      );
    }
  }

  @override
  Future<void> saveProgress(SkillsProgress progress) async {
    try {
      await _storage.setInt(StorageKeys.skillDamageLevel, progress.damageLevel);
      await _storage.setInt(
          StorageKeys.skillEnduranceLevel, progress.enduranceLevel);
      await _storage.setInt(StorageKeys.skillLifeLevel, progress.lifeLevel);
      await _storage.setInt(StorageKeys.skillSpeedLevel, progress.speedLevel);
    } catch (e) {
      throw ErrorService.toServiceException(
        e,
        fallback: 'No se pudo guardar el progreso de habilidades',
      );
    }
  }
}
