import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/providers/background_provider.dart';
import 'package:shadow_game/app/features/levels/providers/player_provider.dart';
import 'package:shadow_game/app/features/levels/widgets/gestures.dart';
import 'package:shadow_game/app/features/levels/widgets/interface_buttons.dart';
import 'package:shadow_game/app/features/levels/widgets/objects.dart';
import 'package:shadow_game/app/features/levels/widgets/parallax_background.dart';
import 'package:shadow_game/app/features/shared/widgets/skills_dialog.dart';
import 'package:shadow_game/app/features/levels/widgets/characters.dart'
    as characters;

class LevelTwoScreen extends ConsumerStatefulWidget {
  const LevelTwoScreen({super.key});

  @override
  LevelTwoScreenState createState() => LevelTwoScreenState();
}

class LevelTwoScreenState extends ConsumerState<LevelTwoScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(playerProvider.notifier).resetData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final backgroundState = ref.watch(backgroundProvider);
    return Scaffold(
      body: SkillProvider(
        child: InterfaceButtons(
          child: characters.Characters(
            //porque no permite poner el nombre Characters por si solo porque ya hay otra clase con ese nombre
            child: Objects(
              child: Gestures(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_two/underground.png',
                        positionLeft: backgroundState.backgroundPosition,
                        speed: playerState.speed,
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                    Positioned(
                      bottom: -MediaQuery.of(context).size.height * 0.1,
                      left: 0,
                      right: 0,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_two/ground.png',
                        positionLeft: backgroundState.backgroundPosition,
                        speed: playerState.speed,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
