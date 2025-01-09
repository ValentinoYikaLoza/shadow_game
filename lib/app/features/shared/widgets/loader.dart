import 'package:flutter/material.dart';
import 'package:shadow_game/app/config/constants/app_colors.dart';
import 'package:shadow_game/app/features/levels/models/animation.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';

final GlobalKey<_LoaderContentState> _loaderKey =
    GlobalKey<_LoaderContentState>();

class Loader {
  static show([String message = 'Cargando']) {
    if (_loaderKey.currentState != null) {
      _loaderKey.currentState!.show(message);
    }
  }

  static dissmiss() {
    if (_loaderKey.currentState != null) {
      _loaderKey.currentState!.dismiss();
    }
  }
}

class LoaderProvider extends StatelessWidget {
  const LoaderProvider({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _LoaderContent(
      key: _loaderKey,
      child: child,
    );
  }
}

class _LoaderContent extends StatefulWidget {
  const _LoaderContent({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<_LoaderContent> createState() => _LoaderContentState();
}

class _LoaderContentState extends State<_LoaderContent> {
  bool showLoader = false;
  String message = 'Loading';

  show([String message = 'Loading']) {
    setState(() {
      showLoader = true;
      this.message = message;
    });
  }

  dismiss() {
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (showLoader)
          Container(
            color: AppColors.gray3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomGif(
                        images: ShadowAnimation.walk.images,
                        width: 70,
                        loop: true,
                      ),
                      CustomGif(
                        images: PlayerAnimation.walk.images,
                        width: 50,
                        loop: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: Image.asset(
                        'assets/gifs/loading.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
