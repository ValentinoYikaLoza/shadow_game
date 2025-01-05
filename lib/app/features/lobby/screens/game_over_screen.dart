import 'package:flutter/material.dart';
import 'package:shadow_game/app/config/constants/app_colors.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/lobby/routes/lobby_routes.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game/app/features/shared/widgets/loader.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray3,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/icon.jpg',
          ),
          Positioned(
            top: screenSize.height * 0.45,
            left: screenSize.width - ((screenSize.width * 0.55)),
            child: CustomButton(
              imagePath: 'assets/images/lobby/game_over.png',
              width: screenSize.width * 0.5,
              onPressed: () {
                Loader.show();
                AppRouter.go(LobbyRoutes.startGame.path);
                Loader.dissmiss();
              },
            ),
          ),
        ],
      ),
    );
  }
}
