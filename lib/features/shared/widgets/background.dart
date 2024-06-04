import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class Background extends ParallaxComponent {
  double velocity;
  String backgroundImage;

  Background(this.velocity, this.backgroundImage);

  Future<void> initialize() async {
    parallax = await Parallax.load(
      [ParallaxImageData(backgroundImage)],
      baseVelocity: Vector2(velocity, 0),
      velocityMultiplierDelta: Vector2(1.6, 1.0),
      size: Vector2(201, 201),
    );
  }

  void updateVelocity(double newVelocity) {
    velocity = newVelocity;
    parallax!.baseVelocity = Vector2(velocity, 0);
  }
}
