import 'package:flutter/widgets.dart';

class ParallaxBackground extends StatelessWidget {
  final String imagePath;
  final double positionLeft;
  final double speed;
  final double? height;

  const ParallaxBackground({
    super.key,
    required this.imagePath,
    required this.positionLeft,
    required this.speed,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final imageHeight = height ?? constraints.maxHeight;

        // Calculate how many images we need to cover the width
        final count = (screenWidth / screenWidth).ceil() + 2;

        return SizedBox(
          width: screenWidth,
          height: imageHeight,
          child: Stack(
            fit: StackFit.passthrough,
            children: List.generate(count, (index) {
              double actualPosition = positionLeft % screenWidth;
              double xPosition =
                  (index * screenWidth + actualPosition) - screenWidth;

              return Positioned(
                left: xPosition,
                child: Image.asset(
                  imagePath,
                  width: screenWidth,
                  height: imageHeight,
                  fit: BoxFit.cover, // Ensure image covers without distortion
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
