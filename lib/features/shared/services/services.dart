import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/features/shared/providers/loader_provider.dart';
import 'package:shadow_game/features/shared/widgets/loader.dart';

class Services extends ConsumerStatefulWidget {
  const Services({super.key, required this.child});
  final Widget child;

  @override
  ServicesState createState() => ServicesState();
}

class ServicesState extends ConsumerState<Services> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(loaderProvider);    

    return Stack(
      children: [
        widget.child,
        if (loader.loading) Loader(message: loader.title),
      ],
    );
  }
}
