import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadow_game/features/shared/widgets/image_container.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
              onTap: () {
                context.go('/level_one');
              },
              child: const ImageContainer(
                imagePath: 'assets/imgs/lobby/startGameButton.png',
              ))),
    );
  }
}
