import 'package:flutter/widgets.dart';
import 'package:shadow_game/app/features/levels/domain/entities/animations.dart';
import 'package:shadow_game/app/features/levels/domain/entities/coin.dart';
import 'package:shadow_game/app/shared/widgets/custom_gif.dart';

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
