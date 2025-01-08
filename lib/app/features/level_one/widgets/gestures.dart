import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/providers/dog_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/player_provider.dart';

class Gestures extends ConsumerStatefulWidget {
  final Widget child;

  const Gestures({super.key, required this.child});

  @override
  GesturesState createState() => GesturesState();
}

class GesturesState extends ConsumerState<Gestures> {
  Timer? _leftTimer;
  Timer? _rightTimer;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final playerNotifier = ref.read(playerProvider.notifier);
    final playerState = ref.read(playerProvider);

    return Stack(
      children: [
        widget.child,
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) {
                  _leftTimer =
                      Timer.periodic(const Duration(milliseconds: 16), (_) {
                    playerNotifier.moveLeft();
                  });
                },
                onVerticalDragStart: (_){
                  playerNotifier.jump();
                },
                // onLongPressMoveUpdate: (_) => playerNotifier.moveLeft(),
                onLongPressEnd: (_) {
                  _leftTimer?.cancel();
                  playerNotifier.stopMovement();
                  ref.read(dogProvider.notifier).stopMovement(); 
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) {
                  _rightTimer =
                      Timer.periodic(const Duration(milliseconds: 16), (_) {
                    playerNotifier.moveRight(
                        playerState.currentStatus == PlayerStatus.tutorial
                            ? screenWidth - 100
                            : screenWidth / 1.5);
                  });
                },
                onVerticalDragStart: (_){
                  playerNotifier.jump();
                },
                // onLongPressMoveUpdate: (_) => playerNotifier.moveRight(screenWidth / 1.5),
                onLongPressEnd: (_) {
                  _rightTimer?.cancel();
                  playerNotifier.stopMovement();
                  ref.read(dogProvider.notifier).stopMovement(); 
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
