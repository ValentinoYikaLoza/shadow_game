import 'package:go_router/go_router.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/levels/routes/levels_routes.dart';
import 'package:shadow_game/app/features/lobby/routes/lobby_routes.dart';

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        return '/start-game';
      },
    ),
    LobbyRoutes.startGame,
    LobbyRoutes.gameOver,
    LobbyRoutes.tutorial,
    LevelsRoutes.levelOne,
    LevelsRoutes.levelTwo,
  ],
);
