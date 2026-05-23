import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_game/app/features/skills/data/datasources/skills_local_datasource.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/shared/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SkillsLocalDatasource datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    datasource = SkillsLocalDatasource(storage);
  });

  test('returns default progress (every skill at level 1) when empty', () async {
    final progress = await datasource.getProgress();

    expect(progress, const SkillsProgress());
    expect(progress.damageLevel, 1);
    expect(progress.speedLevel, 1);
  });

  test('persists progress and reads it back', () async {
    const saved = SkillsProgress(
      damageLevel: 3,
      enduranceLevel: 2,
      lifeLevel: 2,
      speedLevel: 1,
    );

    await datasource.saveProgress(saved);
    final loaded = await datasource.getProgress();

    expect(loaded, saved);
  });
}
