import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/levels/providers/chest_provider.dart';
import 'package:shadow_game/app/features/levels/providers/door_provider.dart';
import 'package:shadow_game/app/features/levels/providers/spider_provider.dart';
import 'package:shadow_game/app/features/levels/widgets/chest_widget.dart';
import 'package:shadow_game/app/features/levels/widgets/door_widget.dart';

class Objects extends ConsumerStatefulWidget {
  final Widget child;
  const Objects({
    super.key,
    required this.child,
  });

  @override
  ObjectsState createState() => ObjectsState();
}

class ObjectsState extends ConsumerState<Objects> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(doorProvider.notifier).addObject();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doorState = ref.watch(doorProvider);
    final chestState = ref.watch(chestProvider);
    final spiderState = ref.watch(spiderProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final groundHeight = screenHeight * 0.3;
    return Stack(
      children: [
        widget.child,
        //Puerta
        ...List.generate(
          doorState.objects.length,
          (index) {
            final door = doorState.objects[index];
            return DoorWidget(
              door: door,
              groundHeight: groundHeight - 28,
            );
          },
        ),
        // Cofre
        ...List.generate(
          chestState.objects.length,
          (index) {
            final chest = chestState.objects[index];
            return ChestWidget(
              key: ValueKey('chest_$index'), // Add unique key
              chest: chest,
              groundHeight: groundHeight,
              isBoss: index == spiderState.maxEnemies - 1,
            );
          },
        ),
      ],
    );
  }
}
