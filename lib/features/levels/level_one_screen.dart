import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/features/shared/providers/player_provider.dart';
import 'package:shadow_game/features/shared/providers/position_provider.dart';
import 'package:shadow_game/features/shared/widgets/image_container.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LevelOneScreenView(),
    );
  }
}

class LevelOneScreenView extends ConsumerStatefulWidget {
  const LevelOneScreenView({
    super.key,
  });

  @override
  LevelOneScreenViewState createState() => LevelOneScreenViewState();
}

class LevelOneScreenViewState extends ConsumerState<LevelOneScreenView> {
  bool isTapping = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final position = ref.watch(positionProvider);
    return Stack(
      children: [
        ImageContainer(
          imagePath: 'assets/imgs/level_one/background.png',
          width: width,
        ),
        Positioned(
          top: height / 2,
          left: 400,
          child: IconButton(
            onPressed: () {
              setState(() {
                isTapping = true;
                ref.read(playerProvider.notifier).walk(true);
                ref.read(positionProvider.notifier).changeX(10, width);
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        Positioned(
          top: (height / 2) + 150,
          left: (width / 2) - 85,
          child: ImageContainer(
            imagePath: 'assets/imgs/shared/skillButton.png',
            width: width / 5,
            height: height * 0.06,
          ),
        ),
        Positioned(
          top: 276,
          left: position.x,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: !isTapping
                ? ImageContainer(
                    imagePath: 'assets/imgs/player/stay.gif',
                    width: width * 0.035,
                    height: height * 0.12,
                  )
                : ImageContainer(
                    imagePath: 'assets/imgs/player/walk.gif',
                    width: width * 0.04,
                    height: height * 0.12,
                  ),
          ),
        ),
      ],
    );
  }
}
