import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shadow_game/app/config/constants/app_colors.dart';
import 'package:shadow_game/app/shared/enums/snackbar_type.dart';
import 'package:shadow_game/app/shared/functions/random_string.dart';
import 'package:shadow_game/app/shared/widgets/custom_gif.dart';

// Re-export so existing `import '.../snackbar.dart'` call sites keep resolving
// `SnackbarType` without an extra import.
export 'package:shadow_game/app/shared/enums/snackbar_type.dart';

final GlobalKey<_SnackbarContentState> _snackbarKey =
    GlobalKey<_SnackbarContentState>();

class SnackbarService {
  static SnackbarModel? show(
    String message, {
    SnackbarType type = SnackbarType.normal,
  }) {
    if (_snackbarKey.currentState != null) {
      final newSnackbar = _snackbarKey.currentState!.addSnackbar(message, type);
      return newSnackbar;
    }

    return null;
  }

  static remove(SnackbarModel? snackbar) {
    if (_snackbarKey.currentState != null) {
      _snackbarKey.currentState!.removeSnackbar(snackbar);
    }
  }
}

class SnackbarProvider extends StatelessWidget {
  const SnackbarProvider({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _SnackbarContent(
      key: _snackbarKey,
      child: child,
    );
  }
}

class _SnackbarContent extends StatefulWidget {
  const _SnackbarContent({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<_SnackbarContent> createState() => _SnackbarContentState();
}

class _SnackbarContentState extends State<_SnackbarContent> {
  List<SnackbarModel> snackbars = [];

  SnackbarModel addSnackbar(String message, SnackbarType type) {
    final SnackbarModel newSnackbar = SnackbarModel(
      id: generateRandomString(10),
      message: message,
      type: type,
    );

    setState(() {
      // Limpia todos los snackbars actuales antes de agregar uno nuevo
      snackbars.clear();
      snackbars.add(newSnackbar);
    });

    if (type == SnackbarType.normal || type == SnackbarType.animated) {
      Future.delayed(const Duration(seconds: 4), () {
        removeSnackbar(newSnackbar);
      });
    }

    return newSnackbar;
  }

  removeSnackbar(SnackbarModel? snackbar) {
    if (snackbar == null) return;
    setState(() {
      snackbars.remove(snackbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          if (widget.child != null) widget.child!,
          Positioned(
            top: 20,
            left: screenWidth / 2 - (screenWidth * 0.5 / 2),
            child: Wrap(
              direction: Axis.vertical,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              children: snackbars.reversed.toList().map((snackbar) {
                if (snackbar.type == SnackbarType.normal) {
                  return _CustomSnackbar(
                    message: snackbar.message,
                    type: snackbar.type,
                    onClose: () {
                      removeSnackbar(snackbar);
                    },
                  );
                } else if (snackbar.type == SnackbarType.animated) {
                  return _AnimatedSnackbar(
                    message: snackbar.message,
                    onClose: () {
                      removeSnackbar(snackbar);
                    },
                  );
                }
                return Container();
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSnackbar extends StatelessWidget {
  const _CustomSnackbar({
    required this.message,
    required this.onClose,
    this.type = SnackbarType.normal,
  });

  final String message;
  final SnackbarType type;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              minHeight: 74,
            ),
            padding: const EdgeInsets.only(),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: AppColors.blue,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 83,
                  color: AppColors.blue,
                ),
                const SizedBox(
                  width: 11,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: const CustomGif(
                    images: ['assets/images/lobby/shadow.png'],
                    width: 50,
                    loop: false,
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue,
                      height: 20 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedSnackbar extends StatefulWidget {
  const _AnimatedSnackbar({
    required this.message,
    required this.onClose,
  });

  final String message;
  final void Function() onClose;

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar> {
  late String displayedText = '';
  late Timer _textTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTextAnimation();
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentIndex < widget.message.length) {
        setState(() {
          displayedText += widget.message[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              minHeight: 74,
            ),
            padding: const EdgeInsets.only(),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: AppColors.blue,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 83,
                  color: AppColors.blue,
                ),
                const SizedBox(
                  width: 11,
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: const CustomGif(
                    images: ['assets/images/lobby/shadow.png'],
                    width: 50,
                    loop: false,
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    displayedText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue,
                      height: 20 / 16,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SnackbarModel {
  final String id;
  final String message;
  final SnackbarType type;

  SnackbarModel({
    required this.id,
    required this.message,
    required this.type,
  });
}
