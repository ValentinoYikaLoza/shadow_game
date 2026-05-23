import 'package:get_it/get_it.dart';
import 'package:shadow_game/app/features/levels/data/datasources/level_progress_local_datasource.dart';
import 'package:shadow_game/app/features/levels/data/repositories/level_progress_repository_impl.dart';
import 'package:shadow_game/app/features/levels/domain/datasources/level_progress_datasource.dart';
import 'package:shadow_game/app/features/levels/domain/repositories/level_progress_repository.dart';
import 'package:shadow_game/app/features/skills/data/datasources/skills_local_datasource.dart';
import 'package:shadow_game/app/features/skills/data/repositories/skills_repository_impl.dart';
import 'package:shadow_game/app/features/skills/domain/datasources/skills_datasource.dart';
import 'package:shadow_game/app/features/skills/domain/repositories/skills_repository.dart';
import 'package:shadow_game/app/shared/services/storage_service.dart';

/// Single service locator for the app.
final getIt = GetIt.instance;

/// Registers core services, datasources and repositories.
///
/// Must be awaited during bootstrap (before `runApp`) because it loads
/// `SharedPreferences` and the presentation providers resolve their
/// repositories from [getIt] as soon as they are first read.
Future<void> setup() async {
  // --- Core ---
  final storage = await StorageService.init();
  getIt.registerSingleton<StorageService>(storage);

  // --- Skills feature ---
  getIt.registerLazySingleton<SkillsDatasource>(
    () => SkillsLocalDatasource(getIt<StorageService>()),
  );
  getIt.registerLazySingleton<SkillsRepository>(
    () => SkillsRepositoryImpl(getIt<SkillsDatasource>()),
  );

  // --- Levels feature ---
  getIt.registerLazySingleton<LevelProgressDatasource>(
    () => LevelProgressLocalDatasource(getIt<StorageService>()),
  );
  getIt.registerLazySingleton<LevelProgressRepository>(
    () => LevelProgressRepositoryImpl(getIt<LevelProgressDatasource>()),
  );
}
