import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_game/app/features/levels/presentation/providers/player_provider.dart';
import 'package:shadow_game/app/features/skills/domain/entities/skill.dart';
import 'package:shadow_game/app/features/skills/domain/repositories/skills_repository.dart';
import 'package:shadow_game/app/features/skills/presentation/providers/skills_provider.dart';
import 'package:shadow_game/di.dart';

class _FakeSkillsRepository implements SkillsRepository {
  SkillsProgress stored = const SkillsProgress();

  @override
  Future<SkillsProgress> getProgress() async => stored;

  @override
  Future<void> saveProgress(SkillsProgress progress) async {
    stored = progress;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    getIt.registerSingleton<SkillsRepository>(_FakeSkillsRepository());
  });

  tearDown(() async {
    await getIt.reset();
  });

  /// Builds a container, keeps the skills/player providers alive (both are
  /// autoDispose-sensitive) and waits for SkillNotifier._load() to settle.
  Future<ProviderContainer> buildContainer() async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(skillProvider, (_, __) {});
    container.listen(playerProvider, (_, __) {});
    await Future<void>.delayed(Duration.zero);
    return container;
  }

  test('leveling a skill spends coins and raises the level', () async {
    final container = await buildContainer();
    container.read(playerProvider.notifier).addCoins(10);

    container.read(skillProvider.notifier).levelUpSkill(SkillType.damage);

    expect(container.read(skillProvider).currentLevelDamage, 2);
    expect(container.read(playerProvider).coins, 9); // 10 - cost(1)
    expect(container.read(playerProvider).damage, 2);
  });

  test('damage scales to 3 at level 3 and caps there', () async {
    final container = await buildContainer();
    container.read(playerProvider.notifier).addCoins(100);
    final skills = container.read(skillProvider.notifier);

    skills.levelUpSkill(SkillType.damage); // 1 -> 2 (cost 1)
    skills.levelUpSkill(SkillType.damage); // 2 -> 3 (cost 5)

    expect(container.read(skillProvider).currentLevelDamage, 3);
    expect(container.read(playerProvider).damage, 3);
    expect(container.read(playerProvider).coins, 94); // 100 - 1 - 5

    skills.levelUpSkill(SkillType.damage); // capped at 3, no change/charge
    expect(container.read(skillProvider).currentLevelDamage, 3);
    expect(container.read(playerProvider).coins, 94);
  });

  test('does not level up without enough coins', () async {
    final container = await buildContainer();
    // Player starts with 0 coins.

    container.read(skillProvider.notifier).levelUpSkill(SkillType.speed);

    expect(container.read(skillProvider).currentLevelSpeed, 1);
    expect(container.read(playerProvider).coins, 0);
  });

  test('restores persisted skill levels on load', () async {
    (getIt<SkillsRepository>() as _FakeSkillsRepository).stored =
        const SkillsProgress(damageLevel: 3, speedLevel: 2);

    final container = await buildContainer();

    expect(container.read(skillProvider).currentLevelDamage, 3);
    expect(container.read(skillProvider).currentLevelSpeed, 2);
    expect(container.read(skillProvider).currentLevelLife, 1);
  });
}
