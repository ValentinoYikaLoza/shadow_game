import 'dart:math';

const _chars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

final _random = Random();

/// Generates a random alphanumeric string of [length] characters.
///
/// Pure reusable utility (used to give each snackbar a unique id).
String generateRandomString(int length) {
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
    ),
  );
}
