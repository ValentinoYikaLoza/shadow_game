import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_game/app/shared/functions/random_string.dart';

void main() {
  group('generateRandomString', () {
    test('returns a string of the requested length', () {
      expect(generateRandomString(0), isEmpty);
      expect(generateRandomString(10).length, 10);
      expect(generateRandomString(64).length, 64);
    });

    test('uses only alphanumeric characters', () {
      final value = generateRandomString(500);
      expect(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value), isTrue);
    });
  });
}
