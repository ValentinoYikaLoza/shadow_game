import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/models/animation.dart';
import 'package:shadow_game/app/features/level_one/providers/dog_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/spider_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';
import 'package:shadow_game/app/features/level_one/widgets/spider_widget.dart';

class Characters extends ConsumerStatefulWidget {
  final Widget child;
  const Characters({
    super.key,
    required this.child,
  });

  @override
  CharactersState createState() => CharactersState();
}

class CharactersState extends ConsumerState<Characters> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(spiderProvider.notifier).addEnemy();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final dogState = ref.watch(dogProvider);
    final spiderState = ref.watch(spiderProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final groundHeight = screenHeight * 0.3;
    return Stack(
      children: [
        widget.child,
        // Enemigo araña
        ...List.generate(
          spiderState.enemies.length,
          (index) {
            final enemy = spiderState.enemies[index];
            return SpiderWidget(
              spider: enemy,
              isBoss: index == spiderState.maxEnemies - 1,
            );
          },
        ),
        // Perro
        Positioned(
          bottom: groundHeight,
          left: dogState.xCoords,
          child: GestureDetector(
            onLongPressDown: (_) {
              setState(() {
                ref.read(dogProvider.notifier).updateState(ShadowAnimation.bark);
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                ref.read(dogProvider.notifier).updateState(ShadowAnimation.sit);
              });
            },
            onTapUp: (_) {
              setState(() {
                ref.read(dogProvider.notifier).updateState(ShadowAnimation.sit);
              });
            },
            child: CustomGif(
              images: dogState.currentState.images,
              width: 80,
              loop: dogState.currentState.loop,
              flip: dogState.currentDirection == Directions.left,
            ),
          ),
        ),
        // Jugador
        Positioned(
          bottom: groundHeight + playerState.yCoords,
          left: playerState.xCoords,
          child: GestureDetector(
            onLongPressDown: (_) {
              setState(() {});
            },
            child: CustomGif(
              images: playerState.currentState.images,
              width: 50,
              loop: playerState.currentState.loop,
              flip: playerState.currentDirection == Directions.left,
            ),
          ),
        ),
      ],
    );
  }
}
