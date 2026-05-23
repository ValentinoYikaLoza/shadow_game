import 'package:equatable/equatable.dart';

/// The four upgradable player skills.
enum SkillType { damage, endurance, life, speed }

/// Every concrete skill level and the icon used to render it.
enum SkillLevels {
  // Damage Skills
  damageLevel1(SkillType.damage, 1, 'assets/images/shared/damage/damage_level1.png'),
  damageLevel2(SkillType.damage, 2, 'assets/images/shared/damage/damage_level2.png'),
  damageLevel3(SkillType.damage, 3, 'assets/images/shared/damage/damage_level3.png'),

  // Endurance Skills
  enduranceLevel1(SkillType.endurance, 1, 'assets/images/shared/endurance/endurance_level1.png'),
  enduranceLevel2(SkillType.endurance, 2, 'assets/images/shared/endurance/endurance_level2.png'),
  enduranceLevel3(SkillType.endurance, 3, 'assets/images/shared/endurance/endurance_level3.png'),

  // Life Skills
  lifeLevel1(SkillType.life, 1, 'assets/images/shared/life/life_level1.png'),
  lifeLevel2(SkillType.life, 2, 'assets/images/shared/life/life_level2.png'),
  lifeLevel3(SkillType.life, 3, 'assets/images/shared/life/life_level3.png'),

  // Speed Skills
  speedLevel1(SkillType.speed, 1, 'assets/images/shared/speed/speed_level1.png'),
  speedLevel2(SkillType.speed, 2, 'assets/images/shared/speed/speed_level2.png'),
  speedLevel3(SkillType.speed, 3, 'assets/images/shared/speed/speed_level3.png');

  final SkillType skillType;
  final double level;
  final String image;
  const SkillLevels(this.skillType, this.level, this.image);
}

/// The persistable progress of every skill (the level reached for each one).
///
/// Uses [Equatable] value-equality on purpose: it is a plain data record that
/// is compared and persisted by value (unlike the game-loop entities, which
/// keep identity semantics for in-list lookups).
class SkillsProgress extends Equatable {
  final int damageLevel;
  final int enduranceLevel;
  final int lifeLevel;
  final int speedLevel;

  const SkillsProgress({
    this.damageLevel = 1,
    this.enduranceLevel = 1,
    this.lifeLevel = 1,
    this.speedLevel = 1,
  });

  SkillsProgress copyWith({
    int? damageLevel,
    int? enduranceLevel,
    int? lifeLevel,
    int? speedLevel,
  }) {
    return SkillsProgress(
      damageLevel: damageLevel ?? this.damageLevel,
      enduranceLevel: enduranceLevel ?? this.enduranceLevel,
      lifeLevel: lifeLevel ?? this.lifeLevel,
      speedLevel: speedLevel ?? this.speedLevel,
    );
  }

  @override
  List<Object?> get props =>
      [damageLevel, enduranceLevel, lifeLevel, speedLevel];
}
