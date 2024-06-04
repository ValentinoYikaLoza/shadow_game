
import 'package:flutter_riverpod/flutter_riverpod.dart';

final velocityProvider = StateProvider<double>((ref) {
  return 0; // Valor inicial de velocity
});

final animationProvider = StateProvider<String>((ref) {
  return 'player/stay/stay.png'; 
});

final animationLengthProvider = StateProvider<int>((ref) {
  return 4; 
});

final isGoingRightProvider = StateProvider<bool>((ref) {
  return true; 
});