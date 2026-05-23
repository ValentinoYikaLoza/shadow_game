import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/features/skills/presentation/providers/skills_provider.dart';
import 'package:shadow_game/app/shared/widgets/custom_button.dart';

final GlobalKey<_SkillDialogContentState> _skillDialogKey = GlobalKey<_SkillDialogContentState>();

class SkillDialog {
  static void show() => _skillDialogKey.currentState?.show();
  static void dismiss() => _skillDialogKey.currentState?.dismiss();
}

class SkillProvider extends StatelessWidget {
  const SkillProvider({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return _SkillDialogContent(key: _skillDialogKey, child: child);
  }
}

class _SkillDialogContent extends ConsumerStatefulWidget {
  const _SkillDialogContent({super.key, this.child});
  final Widget? child;

  @override
  _SkillDialogContentState createState() => _SkillDialogContentState();
}

class _SkillDialogContentState extends ConsumerState<_SkillDialogContent> {
  bool _isDialogVisible = false;

  void show() => setState(() => _isDialogVisible = true);
  void dismiss() => setState(() => _isDialogVisible = false);

  @override
  Widget build(BuildContext context) {
    final skillState = ref.watch(skillProvider);
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        if (_isDialogVisible) _buildDialog(skillState),
      ],
    );
  }

  Widget _buildDialog(SkillState skillState) {
    return Stack(
      children: [
        _buildBlurLayer(),
        _buildDialogContent(skillState),
      ],
    );
  }

  Widget _buildBlurLayer() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: dismiss,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildDialogContent(SkillState skillState) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset('assets/images/shared/skillBackground.png'),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: SkillType.values.map((skillType) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomButton(
                    imagePath: _getSkillImage(skillState, skillType),
                    width: 100,
                    onPressed: () => _levelUpSkill(skillType),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getSkillImage(SkillState skillState, SkillType skillType) {
    switch (skillType) {
      case SkillType.damage:
        return skillState.currentDamageImage.image;
      case SkillType.endurance:
        return skillState.currentEnduranceImage.image;
      case SkillType.life:
        return skillState.currentLifeImage.image;
      case SkillType.speed:
        return skillState.currentSpeedImage.image;
    }
  }

  void _levelUpSkill(SkillType skillType) {
    setState(() {
      ref.read(skillProvider.notifier).levelUpSkill(skillType);
    });
  }
}
