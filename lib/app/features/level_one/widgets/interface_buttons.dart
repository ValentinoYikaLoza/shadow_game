import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/config/constants/app_colors.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/level_one/models/animation.dart';
import 'package:shadow_game/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game/app/features/lobby/routes/lobby_routes.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game/app/features/level_one/widgets/lifebar.dart';
import 'package:shadow_game/app/features/shared/widgets/skills_dialog.dart';

class InterfaceButtons extends ConsumerWidget {
  final Widget child;
  const InterfaceButtons({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    final backgroundState = ref.watch(backgroundProvider);
    final playerState = ref.watch(playerProvider);
    final screenSize = MediaQuery.of(context).size;
    final groundHeight = screenSize.height * 0.13;
    return Stack(
      children: [
        child,
        // coords
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'x: ${backgroundState.xCoords}',
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                height: 21 / 18,
                decoration: TextDecoration.none),
          ),
        ),
        // coins
        Positioned(
          top: 50,
          right: 20,
          child: Row(
            children: [
              Text(
                '${playerState.coins.round()}',
                style: const TextStyle(
                  fontSize: 26,
                  color: AppColors.golden,
                  fontWeight: FontWeight.w900,
                  height: 28 / 26,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 10),
              CustomGif(
                images: CoinAnimation.looping.images,
                width: 26,
                loop: true,
              ),
            ],
          ),
        ),
        // players life
        Positioned(
          top: 25,
          right: 20,
          child: Lifebar(
            totalHearts: playerState.maxLives,
            fullHearts: playerState.currentLives,
          ),
        ),
        // skill button
        if (playerState.currentStatus != PlayerStatus.tutorial)
          Positioned(
            bottom: groundHeight,
            left: screenSize.width / 2 - (screenSize.width * 0.2) / 2,
            child: CustomButton(
              imagePath: 'assets/images/lobby/skills.png',
              width: screenSize.width * 0.2,
              onPressed: () {
                SkillDialog.show();
              },
            ),
          ),
        if (playerState.currentStatus != PlayerStatus.tutorial)
          Positioned(
            bottom: screenSize.height * 0.08,
            left: screenSize.width / 2 - (screenSize.width * 0.15) / 2,
            child: CustomButton(
              imagePath: 'assets/images/lobby/tutorial.png',
              width: screenSize.width * 0.15,
              onPressed: () {
                AppRouter.push(LobbyRoutes.tutorial.path);
              },
            ),
          ),
      ],
    );
  }
}
