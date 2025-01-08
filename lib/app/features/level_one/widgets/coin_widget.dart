import 'package:flutter/widgets.dart';
import 'package:shadow_game/app/features/level_one/models/animation.dart';
import 'package:shadow_game/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game/app/features/shared/widgets/custom_gif.dart';

class CoinWidget extends StatelessWidget {
  final Coin coin;
  const CoinWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return CustomGif(
      images: CoinAnimation.waiting.images,
      width: 28,
      loop: true, // Si la moneda necesita animación constante
    );
  }
}
