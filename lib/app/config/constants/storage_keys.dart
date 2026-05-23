/// Centralised `SharedPreferences` keys so no string is duplicated across
/// datasources.
class StorageKeys {
  const StorageKeys._();

  // Skills feature
  static const skillDamageLevel = 'skill_damage_level';
  static const skillEnduranceLevel = 'skill_endurance_level';
  static const skillLifeLevel = 'skill_life_level';
  static const skillSpeedLevel = 'skill_speed_level';

  // Levels feature
  static const currentLevel = 'current_level';
}
