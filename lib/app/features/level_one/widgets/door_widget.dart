import 'package:flutter/widgets.dart';
import 'package:shadow_game/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';

class DoorWidget extends StatelessWidget {
  final Door door;
  final double groundHeight;
  const DoorWidget({
    super.key,
    required this.door,
    required this.groundHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: groundHeight,
      left: door.xCoords,
      child: Column(
        children: [
          door.doorType == DoorType.start
              ? Image.asset('assets/gifs/home.gif')
              : Image.asset('assets/gifs/next_level.gif'),
          const SizedBox(height: 10),
          CustomGif(
            images: door.currentState.state.images,
            width: 120,
            loop: false,
          )
        ],
      ),
    );
  }
}
