import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:shadow_game/features/shared/widgets/background.dart';
import 'package:shadow_game/features/shared/widgets/player.dart';

class Guardian extends SpriteAnimationComponent {
  final FlameGame gameRef;
  final Background background;
  final Player player;
  bool isGoingRight;
  double offset = 30; // Offset para mantener la mascota al costado del jugador
  double speed = 0;
  double speedIncreased = 100;
  SpriteAnimation? currentAnimation;
  late SpriteAnimation sitAnimation;
  late SpriteAnimation waitAnimation;
  late SpriteAnimation walkAnimation;
  
  Guardian({
    required this.gameRef,
    required this.background,
    required this.player,
    required SpriteAnimation animation,
    required Vector2 position,
    this.isGoingRight = true,
  }) : super(
          animation: animation,
          position: position,
          size: Vector2(80, 60),
        );

  Future<void> loadAnimations() async {
    sitAnimation = await _loadAnimation('shadow/sit/sit.png', 6);
    waitAnimation = await _loadAnimation('shadow/wait/wait.png', 8);
    walkAnimation = await _loadAnimation('shadow/walk/walk.png', 4);
  }

  Future<SpriteAnimation> _loadAnimation(String path, int length,
      [double fps = 0.15]) async {
    return gameRef.loadSpriteAnimation(
      path,
      SpriteAnimationData.sequenced(
        amount: length,
        stepTime: fps,
        textureSize: Vector2(120, 90),
      ),
    );
  }

  void updateDirection(bool newIsGoingRight) {
    if (isGoingRight != newIsGoingRight) {
      flipHorizontally();
      position.x += size.x * (isGoingRight ? 1 : -1);
      isGoingRight = newIsGoingRight;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Sincronizar la animación con el estado del jugador
    if (player.isAttacking) {
      currentAnimation = waitAnimation;
    } else if (player.isMoving) {
      currentAnimation = walkAnimation;
    } else {
      currentAnimation = sitAnimation;
    }

    // Mantener la mascota siempre a la derecha del jugador
    final targetX = player.position.x + offset + 20;

    // Interpolar suavemente la posición actual hacia la posición objetivo
    position.x += (targetX - position.x) * 0.1;

    // Usar la animación actual
    animation = currentAnimation ?? sitAnimation;

    // Actualizar dirección
    updateDirection(player.isGoingRight);

    // Movimiento de la mascota
    if (player.isMoving) {
      position.x += speed * dt;
    }
  }
}
