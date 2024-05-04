import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  const ImageContainer({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
        ),
        image: DecorationImage(
          image: AssetImage(
            imagePath,
          ),
          fit: width != null ? BoxFit.fitWidth : null,
        ),
      ),
    );
  }
}
