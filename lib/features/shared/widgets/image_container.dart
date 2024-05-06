import 'package:flutter/material.dart';
import 'dart:math';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final bool girarHorizontalmente;
  final bool repeat;
  const ImageContainer({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.girarHorizontalmente = false,
    this.repeat = false,
  });

  @override
  Widget build(BuildContext context) {
    return !girarHorizontalmente
        ? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                //border: Border.all(color: Colors.black),
                image: DecorationImage(
              image: AssetImage(
                imagePath,
              ),
              repeat: repeat ? ImageRepeat.repeatX : ImageRepeat.noRepeat,
              fit: width != null ? BoxFit.fitWidth : null,
            )),
          )
        : Transform(
            transform: Matrix4.rotationY(pi),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black),
                  image: DecorationImage(
                image: AssetImage(
                  imagePath,
                ),
                repeat: repeat ? ImageRepeat.repeatX : ImageRepeat.noRepeat,
                fit: width != null ? BoxFit.fitWidth : null,
              )),
            ));
  }
}
