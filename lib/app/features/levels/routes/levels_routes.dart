import 'package:go_router/go_router.dart';
import 'package:shadow_game/app/features/levels/screens/level_one_screen.dart';
import 'package:shadow_game/app/features/levels/screens/level_two_screen.dart';

class LevelsRoutes {
  static GoRoute levelOne = GoRoute(
    path: '/level-one',
    builder: (context, state) => const LevelOneScreen(),
  );

  static GoRoute levelTwo = GoRoute(
    path: '/level-two',
    builder: (context, state) => const LevelTwoScreen(),
  );
}
