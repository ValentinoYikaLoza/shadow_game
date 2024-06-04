import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:shadow_game/features/shared/widgets/joystick.dart';

class HudComponent extends PositionComponent{
  late Joystick joystick;

  @override
  void onLoad() {
    final joystickKnobPaint = BasicPalette.black.withAlpha(500).paint();
    final joystickBackgroundPaint = BasicPalette.black.withAlpha(100).paint();

    joystick = Joystick(
      knob: CircleComponent(radius: 20, paint: joystickKnobPaint),
      background: CircleComponent(radius: 50, paint: joystickBackgroundPaint),
      position: Vector2(750, 320),
    );

    add(joystick);
  }
}
