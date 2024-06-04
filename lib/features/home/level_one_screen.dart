import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadow_game/features/shared/widgets/background.dart';
import 'package:shadow_game/features/shared/widgets/button.dart';
import 'package:shadow_game/features/shared/widgets/guardian.dart';
import 'package:shadow_game/features/shared/widgets/hud.dart';
import 'package:shadow_game/features/shared/widgets/player.dart';
import 'package:shadow_game/features/shared/widgets/tree.dart';

class LevelOneScreen extends FlameGame {
  late Background ground;
  late Background sky;
  late ButtonSprite attack;
  late ButtonSprite cut;
  late ButtonSprite jump;
  late ButtonSprite dance;
  late HudComponent hud;
  late Player player;
  late Guardian shadow;
  double velocity = 0;
  late TreeSprite tree;
  late double treeSpacing;
  List<TreeSprite> trees = [];
  late double lastTreePosition;

  final List<String> treeTypes = [
    'level_one/trees/tree1.png',
    'level_one/trees/tree2.png',
    'level_one/trees/tree3.png',
    'level_one/trees/tree4.png',
    'level_one/trees/tree5.png',
    'level_one/trees/tree6.png',
  ];

  List<double> treePositions = [400, 450, 587, 620, 730];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size.x;
    final screenHeight = size.y;

    sky = await _loadBackground(20, 'level_one/sky.png');
    ground = await _loadBackground(velocity, 'level_one/ground.png');

    attack = await _loadButton('shared/skillButton.png', screenWidth / 2 - 85,
        screenHeight / 2 + 150, Vector2(146, 26), imp);

    hud = HudComponent();
    add(hud);

    _generateInitialTrees();

    player = await _loadPlayer(Vector2(50, screenHeight / 2 + 50));
    add(player);

    shadow = await _loadGuardian(Vector2(80, screenHeight / 2 + 40));
    add(shadow);

    attack = await _loadButton('shared/icons/attack.png', 60, screenHeight - 96,
        Vector2(60, 60), player.attack);
    jump = await _loadButton('shared/icons/jump.png', 120, screenHeight - 120,
        Vector2(45, 45), player.jump);
    dance = await _loadButton('shared/icons/dance.png', 125, screenHeight - 60,
        Vector2(40, 40), player.toggleDance);
    cut = await _loadButton('shared/icons/cut.png', 40, screenHeight - 110,
        Vector2(35, 35), player.chopTree);
  }

  generateTreeOnPlayerMovement() {
    double separationPerNewTree = Random().nextInt(100) + 10;
    if (trees.isEmpty) return;
    if (trees.last.isVisible) {
      _generateTree(
          trees.last.position.x + trees.last.width + separationPerNewTree);
    }
  }

  void _generateInitialTrees() {
    for (var position in treePositions) {
      _generateTree(position);
    }
  }

  Future<void> _generateTree(double xPosition) async {
    final treeType = treeTypes[Random().nextInt(treeTypes.length)];
    tree = await _loadTree(treeType, xPosition);
    trees.add(tree);
  }

  Future<TreeSprite> _loadTree(String image, double position) async {
    final tree = TreeSprite(
      gameRef: this,
      sprite: await loadSprite(image),
      position: Vector2(position, 120),
    );
    add(tree);
    return tree;
  }

  Future<ButtonSprite> _loadButton(String image, double positionX,
      double positionY, Vector2 size, VoidCallback onPressed) async {
    final button = ButtonSprite(
      sprite: await loadSprite(image),
      position: Vector2(positionX, positionY),
      size: size,
      onPressed: onPressed,
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
      hud: hud,
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

  imp() {
    print('hola');
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (player.isMoving) {
      generateTreeOnPlayerMovement();
      print('> cantidad de arboles: ${trees.length}');
    }
  }
}
