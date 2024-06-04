import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:shadow_game/configs/router/app_router.dart';
import 'package:shadow_game/features/shared/widgets/background.dart';
import 'package:shadow_game/features/shared/widgets/button.dart';
import 'package:shadow_game/features/shared/widgets/guardian.dart';
import 'package:shadow_game/features/shared/widgets/hud.dart';
import 'package:shadow_game/features/shared/widgets/player.dart';
import 'package:shadow_game/features/shared/widgets/tree.dart';

class StartScreen extends FlameGame {
  late Background ground;
  late Background sky;
  late TreeSprite tree;
  late Player player;
  late Guardian shadow;
  late HudComponent hud;
  late ButtonSprite start;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size.x;
    final screenHeight = size.y;

    sky = await _loadBackground(20, 'level_one/sky.png');
    ground = await _loadBackground(0, 'level_one/ground.png');
    // tree = await _loadTree(0, 'level_one/tree/tree1.png');

    player = await _loadPlayer(Vector2(50, screenHeight / 2 + 50));
    add(player);

    shadow = await _loadGuardian(Vector2(80, screenHeight / 2 + 40));
    add(shadow);

    add(
      SpriteComponent(
        position: Vector2(screenWidth / 2 - 243, screenHeight / 2 - 52),
        sprite: await loadSprite('lobby/startGameButton.png'),
        // size: Vector2(146, 26),
      ),
    );

    start = await _loadButton(
        'lobby/startGameButton.png', screenWidth / 2 - 243, screenHeight / 2 - 52, startGame);
  }

  // Future<TreeSprite> _loadTree(double velocity, String image) async {
  //   final tree = TreeSprite(velocity, image);
  //   add(tree);
  //   return tree;
  // }

  Future<ButtonSprite> _loadButton(String image, double positionX,
      double positionY, VoidCallback? onPressed) async {
    final button = ButtonSprite(
      sprite: await loadSprite(image),
      position: Vector2(positionX, positionY),
      onPressed: onPressed!
    );
    add(button);
    return button;
  }

  Future<Background> _loadBackground(double velocity, String path) async {
    final background = Background(velocity, path);
    await background.initialize();
    add(background);
    return background;
  }

  Future<Player> _loadPlayer(Vector2 position) async {
    final playerAnimation = await loadSpriteAnimation(
      'player/stay/stay.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2(50, 50),
      ),
    );

    final player = Player(
      gameRef: this,
      background: ground,
      animation: playerAnimation,
      position: position,
    );
    await player.loadAnimations();
    return player;
  }

  Future<Guardian> _loadGuardian(Vector2 position) async {
    final guardianAnimation = await loadSpriteAnimation(
      'shadow/sit/sit.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.15,
        textureSize: Vector2(120, 90),
      ),
    );

    final guardian = Guardian(
      gameRef: this,
      background: ground,
      animation: guardianAnimation,
      player: player,
      position: position,
    );
    await guardian.loadAnimations();
    return guardian;
  }

  startGame(){
    appRouter.go('/level_one');
  }
}
