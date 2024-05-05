import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game/features/shared/providers/provider.dart';
import 'package:shadow_game/features/shared/widgets/widget.dart';

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
  Timer? _timer;

  Color colorRight = Colors.transparent;
  Color colorLeft = Colors.transparent;
  Color colorUp = Colors.transparent;
  Color colorDown = Colors.transparent;
  Color colorCenter = Colors.transparent;
  Color colorDance = Colors.transparent;

  startWalking(double distance, double limit, bool goingRight) {
    ref.read(playerProvider.notifier).walk(true);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (goingRight) {
        ref.read(positionProvider.notifier).moveRight(distance, limit);
      } else {
        ref.read(positionProvider.notifier).moveLeft(distance, limit);
      }
    });
  }

  startJumping(double distance, double limit) {
    ref.read(playerProvider.notifier).jump(true);
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (distance > 0) {
        ref.read(positionProvider.notifier).moveUp(distance, limit);
      } else {
        ref.read(positionProvider.notifier).moveDown(distance, limit);
      }
      // ref.read(positionProvider.notifier).moveDown(distanceY, 45);
    });
  }

  stopWalking() {
    ref.read(playerProvider.notifier).walk(false);
    _timer?.cancel();
  }

  stopJumping() {
    ref.read(playerProvider.notifier).jump(false);
    _timer?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      setState(() {
        ref.read(playerProvider.notifier).stay(true);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final position = ref.watch(positionProvider);
    final player = ref.watch(playerProvider);
    String playerAnimation = '';
    double redimension = 0;

    if (player.isAttacking) {
      playerAnimation = 'assets/imgs/player/attack.gif';
      redimension = width * 0.055;
    }
    if (player.isWalking) {
      playerAnimation = 'assets/imgs/player/walk.gif';
      redimension = width * 0.04;
    }
    if (player.isDancing) {
      playerAnimation = 'assets/imgs/player/dance.gif';
      redimension = width * 0.05;
    }
    if (player.isJumping) {
      playerAnimation = 'assets/imgs/player/jump.gif';
      redimension = width * 0.042;
    }
    if (player.isStaying) {
      playerAnimation = 'assets/imgs/player/stay.gif';
      redimension = width * 0.035;
    }

    // Color color = Colors.white;

    return Stack(
      children: [
        ImageContainer(
          imagePath: 'assets/imgs/level_one/background.png',
          width: width,
        ),
        // ),
        Positioned(
          top: height / 2 + 50,
          left: width / 2 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              colorUp = Colors.white.withOpacity(0.3);
              startJumping(10, 30);
            },
            onTapUp: (_) {
              setState(() {
                colorUp = Colors.transparent;
                ref.read(playerProvider.notifier).stay(true);
                stopJumping();
              });
            },
            onTapCancel: () {
              colorUp = Colors.transparent;
              ref.read(playerProvider.notifier).stay(true);
              stopJumping();
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorUp = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorUp = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorUp,
                icon: Icons.expand_less,
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2 + 60,
          left: width / 2 - 31 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                colorDance = Colors.white.withOpacity(0.3);
                ref.read(playerProvider.notifier).dance(true);
                ref.read(positionProvider.notifier).changeY(43);
              });
            },
            onTapUp: (_) {
              setState(() {
                setState(() {
                  colorDance = Colors.transparent;
                  ref.read(playerProvider.notifier).stay(true);
                });
              });
            },
            onTapCancel: () {
              setState(() {
                colorDance = Colors.transparent;
                ref.read(playerProvider.notifier).stay(true);
              });
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorDance = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorDance = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorDance,
                icon: Icons.accessibility_new,
                size: 30,
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2 + 80 + 50,
          left: width / 2 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                colorDown = Colors.white.withOpacity(0.3);
                ref.read(playerProvider.notifier).stay(true);
              });
            },
            onTapUp: (_) {
              setState(() {
                setState(() {
                  colorDown = Colors.transparent;
                  ref.read(playerProvider.notifier).stay(true);
                });
              });
            },
            onTapCancel: () {
              setState(() {
                colorDown = Colors.transparent;
                ref.read(playerProvider.notifier).stay(true);
              });
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorDown = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorDown = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorDown,
                icon: Icons.expand_more,
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2 + 41 + 50,
          left: width / 2 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                colorCenter = Colors.white.withOpacity(0.3);
                ref.read(playerProvider.notifier).attack(true);
              });
            },
            onTapUp: (_) {
              setState(() {
                setState(() {
                  colorCenter = Colors.transparent;
                  ref.read(playerProvider.notifier).stay(true);
                });
              });
            },
            onTapCancel: () {
              setState(() {
                colorCenter = Colors.transparent;
                ref.read(playerProvider.notifier).stay(true);
              });
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorCenter = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorCenter = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorCenter,
                icon: Icons.radio_button_checked,
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2 + 41 + 50,
          left: width / 2 - 41 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              colorLeft = Colors.white.withOpacity(0.3);
              setState(() {
                startWalking(-10, 50, false);
              });
            },
            onTapUp: (_) {
              setState(() {
                colorLeft = Colors.transparent;
                stopWalking();
              });
            },
            onTapCancel: () {
              colorLeft = Colors.transparent;

              stopWalking();
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorLeft = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorLeft = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorLeft,
                icon: Icons.chevron_left,
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2 + 41 + 50,
          left: width / 2 + 41 + 300,
          child: GestureDetector(
            onTapDown: (_) {
              colorRight = Colors.white.withOpacity(0.3);
              ref.read(positionProvider.notifier).changeY(45);
              startWalking(10, width - 100, true);
            },
            onTapUp: (_) {
              setState(() {
                colorRight = Colors.white.withOpacity(0.1);
                stopWalking();
              });
            },
            onTapCancel: () {
              colorRight = Colors.transparent;
              stopWalking();
            },
            // ref.read(positionProvider.notifier).changeY(45);
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  colorRight = Colors.white.withOpacity(0.1);
                });
              },
              onExit: (_) {
                setState(() {
                  colorRight = Colors.transparent;
                });
              },
              child: ButtonController(
                color: colorRight,
                icon: Icons.chevron_right,
              ),
            ),
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
          top: height / 2 + position.y + 26,
          left: position.x,
          child: ImageContainer(
            imagePath: playerAnimation,
            width: redimension,
            height: height * 0.12,
          ),
        ),
      ],
    );
  }
}

class ButtonController extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double? size;

  const ButtonController({
    super.key,
    required this.icon,
    required this.color,
    this.size,
  });

  @override
  State<ButtonController> createState() => _ButtonControllerState();
}

class _ButtonControllerState extends State<ButtonController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size == null ? 70 : widget.size! + 20,
      height: widget.size == null ? 70 : widget.size! + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: Icon(
        widget.icon,
        color: Colors.white,
        size: widget.size ?? 50,
      ),
    );
  }
}
