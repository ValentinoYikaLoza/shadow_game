import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_game/app/features/levels/data/datasources/level_progress_local_datasource.dart';
import 'package:shadow_game/app/shared/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LevelProgressLocalDatasource datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    datasource = LevelProgressLocalDatasource(storage);
  });

  test('defaults to level 1 when nothing is stored', () async {
    expect(await datasource.getCurrentLevel(), 1);
  });

  test('persists the current level and reads it back', () async {
    await datasource.saveCurrentLevel(2);
    expect(await datasource.getCurrentLevel(), 2);
  });
}
