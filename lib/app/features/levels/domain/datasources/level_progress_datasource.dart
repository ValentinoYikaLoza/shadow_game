/// Contract for reading/writing how far the player has progressed.
abstract class LevelProgressDatasource {
  Future<int> getCurrentLevel();
  Future<void> saveCurrentLevel(int level);
}
