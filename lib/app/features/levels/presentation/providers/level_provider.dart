import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/domain/repositories/level_progress_repository.dart';
import 'package:shadow_game/app/shared/models/service_exception.dart';
import 'package:shadow_game/app/shared/widgets/snackbar.dart';
import 'package:shadow_game/di.dart';

/// Tracks (and persists) which level the player is currently on.
class LevelProgressNotifier extends StateNotifier<int> {
  LevelProgressNotifier() : super(1) {
    _load();
  }

  final LevelProgressRepository _repo = getIt<LevelProgressRepository>();

  Future<void> _load() async {
    try {
      state = await _repo.getCurrentLevel();
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    } catch (_) {
      // Keep level 1 on failure.
    }
  }

  Future<void> setCurrentLevel(int level) async {
    state = level;
    try {
      await _repo.saveCurrentLevel(level);
    } on ServiceException catch (e) {
      SnackbarService.show(e.message);
    } catch (_) {
      // Persistence is best-effort.
    }
  }
}

final currentLevelProvider =
    StateNotifierProvider<LevelProgressNotifier, int>((ref) {
  return LevelProgressNotifier();
});
