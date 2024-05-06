import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shadow_game/features/shared/widgets/image_container.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TestScreenView(),
          ],
        ),
      ],
    );
  }
}

class TestScreenView extends StatefulWidget {
  const TestScreenView({super.key});

  @override
  State<TestScreenView> createState() => _TestScreenViewState();
}

class _TestScreenViewState extends State<TestScreenView> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ImageContainer(
          imagePath: 'assets/imgs/player/walk.gif',
        ),
        SizedBox(width: 200),
        FlipImage(
          imagePath:
              'assets/imgs/player/walk.gif', // Replace with your image path
          width: 50,
          height: 50,
        ),
      ],
    );
  }
}

class FlipImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const FlipImage({
    super.key,
    required this.imagePath,
    this.width = 0,
    this.height = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationY(pi),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
      ),
    );
  }
}
