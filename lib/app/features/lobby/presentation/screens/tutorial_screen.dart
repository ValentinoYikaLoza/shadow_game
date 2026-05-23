import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadow_game/app/config/constants/app_colors.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/background_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/player_provider.dart';
import 'package:shadow_game/app/features/levels/presentation/widgets/gestures.dart';
import 'package:shadow_game/app/features/levels/presentation/widgets/interface_buttons.dart';
import 'package:shadow_game/app/features/levels/presentation/widgets/objects.dart';
import 'package:shadow_game/app/features/levels/presentation/widgets/parallax_background.dart';
import 'package:shadow_game/app/features/levels/presentation/widgets/characters.dart'
    as characters;
import 'package:shadow_game/app/features/lobby/presentation/routes/lobby_routes.dart';
import 'package:shadow_game/app/shared/widgets/custom_gif.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends ConsumerState<TutorialScreen> {
  late int fase;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(playerProvider.notifier).tutorialMode();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final backgroundState = ref.watch(backgroundProvider);
    return Scaffold(
      body: InterfaceButtons(
        child: characters.Characters(
          child: Stack(
            children: [
              Gestures(
                child: Objects(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ParallaxBackground(
                          imagePath: 'assets/images/level_one/sky.png',
                          positionLeft: backgroundState.backgroundPosition,
                          speed: playerState.speed,
                          height: MediaQuery.of(context).size.height * 0.8,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ParallaxBackground(
                          imagePath: 'assets/images/level_one/ground.png',
                          positionLeft: backgroundState.backgroundPosition,
                          speed: playerState.speed,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.04,
                left: MediaQuery.of(context).size.width / 2 -
                    ((MediaQuery.of(context).size.width * 0.6) / 2),
                child: const _TutorialCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialCard extends StatefulWidget {
  const _TutorialCard();

  @override
  State<_TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<_TutorialCard> {
  late String displayedText = '';
  late Timer _textTimer;
  int _currentIndex = 0;
  int _messageIndex = 0;

  final List<String> messages = [
    'Hola soy Shadow, y este es mi juego',
    'te enseñaré lo básico para aprender a moverte',
    'debes mantener presionado para empezar a moverte',
    'nos moveremos a la dirección donde presiones',
    'cuando te encuentres con un enemigo no podrás moverte',
    'tendrás que matar al enemigo, es muy facil...',
    'solo presionas encima del enemigo y le harás daño',
    'consejo: presiona muchas veces para matarlo',
    'una vez muerto podrás seguir avanzando',
    'cuando encuentres un cofre pasa por encima y se abrirá',
    'por ahora solo te da monedas',
    'pero pronto se irán añadiendo otros objetos',
    'las monedas sirven para aumentar tus habilidades',
    'si presionas en skills, podrás subirlas de nivel',
    'eso sería todo, disfruta el juego',
  ];

  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentIndex < messages[_messageIndex].length) {
        setState(() {
          displayedText += messages[_messageIndex][_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
        if (_messageIndex < messages.length - 1) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              _messageIndex++;
              displayedText = '';
              _currentIndex = 0;
              _startTextAnimation();
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              minHeight: 74,
            ),
            padding: const EdgeInsets.only(),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: AppColors.blue,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 83,
                  color: AppColors.blue,
                ),
                const SizedBox(
                  width: 11,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: const CustomGif(
                    images: ['assets/images/lobby/shadow.png'],
                    width: 50,
                    loop: false,
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    displayedText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue,
                      height: 20 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
        if (_messageIndex == messages.length - 1)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  AppRouter.go(LobbyRoutes.startGame.path);
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xCCA9A9A9), // dark gray with opacity 0.8
                      Color(0xFFD3D3D3), // light gray
                    ],
                    center: Alignment(-0.3, -0.3),
                    radius: 0.8,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x80A9A9A9), // dark gray with opacity 0.5
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.blue,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/arrow_back.svg',
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFFFFFF), // white
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
