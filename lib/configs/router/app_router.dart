import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadow_game/features/home/lobby_screen.dart';
import 'package:shadow_game/features/levels/level_one_screen.dart';

Future<String?> externalRedirect(
    BuildContext context, GoRouterState state) async {
  return null;
}

Widget transition({
  required BuildContext context,
  required Animation animation,
  required Widget child,
}) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  var fadeTween = Tween(begin: 0.7, end: 1.0);
  var fadeAnimation = animation.drive(fadeTween);

  return FadeTransition(
    opacity: fadeAnimation,
    child: SlideTransition(position: offsetAnimation, child: child),
  );
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/level_one',
    routes: [
      GoRoute(
        path: '/lobby',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LobbyScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return transition(
                  animation: animation, context: context, child: child);
            },
          );
        },
        redirect: externalRedirect,
      ),
      GoRoute(
          path: '/level_one',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const LevelOneScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return transition(
                    animation: animation, context: context, child: child);
              },
            );
          }),
    ]);
