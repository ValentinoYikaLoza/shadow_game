import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game/app/features/level_one/providers/spider_provider.dart';
import 'package:shadow_game/app/features/level_one/widgets/chest_widget.dart';
import 'package:shadow_game/app/features/level_one/widgets/door_widget.dart';

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
      ref.read(doorProvider.notifier).addDoor();
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
          doorState.doors.length,
          (index) {
            final door = doorState.doors[index];
            return DoorWidget(
              door: door,
              groundHeight: groundHeight - 28,
            );
          },
        ),
        // Cofre
        ...List.generate(
          chestState.chests.length,
          (index) {
            final chest = chestState.chests[index];
            return ChestWidget(
              key: ValueKey('chest_$index'), // Add unique key
              chest: chest,
              groundHeight: groundHeight,
              isBoss: index == spiderState.maxSpiders - 1,
            );
          },
        ),
      ],
    );
  }
}
