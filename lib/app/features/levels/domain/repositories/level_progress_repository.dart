/// Contract the presentation layer depends on for the current-level value.
abstract class LevelProgressRepository {
  Future<int> getCurrentLevel();
  Future<void> saveCurrentLevel(int level);
}
