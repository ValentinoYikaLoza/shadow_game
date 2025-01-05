// import 'package:shadow_game/app/features/level_one/models/data.dart';
// import 'package:shadow_game/app/features/level_one/models/game_object.dart';

// class Enemy extends GameObject {
//   final double currentLives;
//   final double maxLives;
//   final double damage;
//   final ObjectAnimation currentState;
//   final Directions currentDirection;

//   Enemy({
//     required super.xCoords,
//     required super.width,
//     required this.currentLives,
//     required this.maxLives,
//     required this.damage,
//     required this.currentState,
//     required this.currentDirection,
//   });

//   @override
//   Enemy copyWith({
//     double? xCoords,
//     double? width,
//     double? currentLives,
//     double? maxLives,
//     double? damage,
//     ObjectAnimation? currentState,
//     Directions? currentDirection,
//   }) {
//     return Enemy(
//       xCoords: xCoords ?? this.xCoords,
//       width: width ?? this.width,
//       currentLives: currentLives ?? this.currentLives,
//       maxLives: maxLives ?? this.maxLives,
//       damage: damage ?? this.damage,
//       currentState: currentState ?? this.currentState,
//       currentDirection: currentDirection ?? this.currentDirection,
//     );
//   }
// }
