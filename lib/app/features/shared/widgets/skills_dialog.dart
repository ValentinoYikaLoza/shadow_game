import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game/app/features/shared/providers/skills_provider.dart';

final GlobalKey<_SkillDialogContentState> _skillDialogKey =
    GlobalKey<_SkillDialogContentState>();

class SkillDialog {
  static show() {
    if (_skillDialogKey.currentState != null) {
      _skillDialogKey.currentState!.show();
    }
  }

  static dissmiss() {
    if (_skillDialogKey.currentState != null) {
      _skillDialogKey.currentState!.dismiss();
    }
  }
}

class SkillProvider extends StatelessWidget {
  const SkillProvider({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _SkillDialogContent(
      key: _skillDialogKey,
      child: child,
    );
  }
}

class _SkillDialogContent extends ConsumerStatefulWidget {
  const _SkillDialogContent({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  _SkillDialogContentState createState() => _SkillDialogContentState();
}

class _SkillDialogContentState extends ConsumerState<_SkillDialogContent> {
  bool showDialog = false;

  show() {
    setState(() {
      showDialog = true;
    });
  }

  dismiss() {
    setState(() {
      showDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final skillState = ref.watch(skillProvider);
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (showDialog)
          Stack(
            children: [
              // Capa de blur
              Positioned.fill(
                child: GestureDetector(
                  onTap: dismiss,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              // Contenido del diálogo
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset('assets/images/shared/skillBackground.png'),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Row(
                        children: [
                          CustomButton(
                            imagePath: skillState.currentDamageImage.image,
                            width: 100,
                            onPressed: () {
                              setState(() {
                                ref
                                    .read(skillProvider.notifier)
                                    .levelUPDamage();
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            imagePath: skillState.currentEnduranceImage.image,
                            width: 100,
                            onPressed: () {
                              setState(() {
                                ref
                                    .read(skillProvider.notifier)
                                    .levelUPEndurance();
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            imagePath: skillState.currentLifeImage.image,
                            width: 100,
                            onPressed: () {
                              setState(() {
                                ref.read(skillProvider.notifier).levelUPLife();
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            imagePath: skillState.currentSpeedImage.image,
                            width: 100,
                            onPressed: () {
                              setState(() {
                                ref.read(skillProvider.notifier).levelUPSpeed();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
