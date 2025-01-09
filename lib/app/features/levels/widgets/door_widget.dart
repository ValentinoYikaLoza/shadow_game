import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/levels/providers/door_provider.dart';
import 'package:shadow_game/app/features/levels/providers/player_provider.dart';
import 'package:shadow_game/app/features/lobby/routes/lobby_routes.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';

class DoorWidget extends ConsumerWidget {
  final Door door;
  final double groundHeight;
  const DoorWidget({
    super.key,
    required this.door,
    required this.groundHeight,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Positioned(
      bottom: groundHeight,
      left: door.xCoords,
      child: Column(
        children: [
          door.doorType == DoorType.start
              ? CustomButton(
                  imagePath: 'assets/gifs/home.gif',
                  width: 120,
                  onPressed: () {
                    AppRouter.go(LobbyRoutes.startGame.path);
                  },
                )
              : CustomButton(
                  imagePath: 'assets/gifs/next_level.gif',
                  width: 120,
                  onPressed: () {
                    ref.read(playerProvider.notifier).goToNextLevel();
                  },
                ),
          const SizedBox(height: 10),
          CustomGif(
            images: door.currentSprite.images,
            width: 120,
            loop: false,
          )
        ],
      ),
    );
  }
}
