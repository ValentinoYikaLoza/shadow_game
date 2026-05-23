import 'dart:async';
import 'package:flutter/material.dart';

class CustomGif extends StatefulWidget {
  final List<String> images;
  final double width;
  final double? height;
  final bool loop;
  final bool flip;
  final double speed;
  final VoidCallback? onComplete;
  final Key? controller;

  const CustomGif({
    super.key,
    required this.images,
    this.width = 100.0,
    this.height,
    this.loop = true,
    this.flip = false,
    this.speed = 0.1,
    this.onComplete,
    this.controller,
  });

  @override
  CustomGifState createState() => CustomGifState();
}

class CustomGifState extends State<CustomGif> {
  int _currentFrame = 0;
  Timer? _timer;
  List<String> _currentImages = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(CustomGif oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reinitialize if images have changed
    if (oldWidget.images != widget.images) {
      _timer?.cancel();
      _currentFrame = 0;
      _initializeAnimation();
    }
  }

  void _initializeAnimation() {
    _currentImages = widget.images;
    if (_currentImages.isNotEmpty) {
      _timer = Timer.periodic(
        Duration(milliseconds: (widget.speed * 1000).toInt()),
        (timer) {
          setState(() {
            if (_currentFrame + 1 < _currentImages.length) {
              _currentFrame++;
            } else {
              if (widget.loop) {
                _currentFrame = 0;
              } else {
                _timer?.cancel();
              }

              if (widget.onComplete != null) {
                widget.onComplete!();
              }
            }
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentImages.isEmpty) {
      return const Center(child: Text("No images available"));
    }

    final imagePath = _currentImages[_currentFrame];

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(widget.flip ? 3.14159 : 0),
      child: Image.asset(
        imagePath,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        // Add caching to prevent flickering
        gaplessPlayback: true,
        key: widget.controller,
      ),
    );
  }
}
