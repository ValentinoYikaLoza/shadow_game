import 'package:go_router/go_router.dart';
import 'package:shadow_game/app/features/level_one/screens/level_one_screen.dart';

class LevelOneRoutes {
  static GoRoute levelOne = GoRoute(
    path: '/level-one',
    builder: (context, state) => const LevelOneScreen(),
  );
}
