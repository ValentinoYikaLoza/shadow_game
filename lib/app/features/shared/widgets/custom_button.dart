import 'package:flutter/material.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';

class CustomButton extends StatefulWidget {
  final String imagePath;
  final double width;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.imagePath,
    required this.width, // Tamaño por defecto
    required this.onPressed,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed(); // Ejecuta la acción pasada como parámetro
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: TweenAnimationBuilder(
        tween: ColorTween(
          begin: Colors.transparent,
          end: _isPressed ? Colors.white.withOpacity(0.3) : Colors.transparent,
        ),
        duration: const Duration(milliseconds: 200),
        builder: (context, Color? color, child) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
            child: CustomGif(
              images: [widget.imagePath],
              width: widget.width,
              loop: false,
            ),
          );
        },
      ),
    );
  }
}
