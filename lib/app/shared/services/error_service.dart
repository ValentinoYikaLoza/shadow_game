import 'package:shadow_game/app/shared/models/service_exception.dart';

/// Translates any thrown object into a [ServiceException].
///
/// The game is offline today, so there is no HTTP client to inspect, but the
/// helper already knows how to read a `message`/`mensaje`/`msg` field from a
/// map. That keeps the contract identical for the day a backend is added: every
/// datasource catches `Object e` and calls
/// `ErrorService.toServiceException(e, fallback: '...')`.
class ErrorService {
  const ErrorService._();

  static const _messageKeys = ['message', 'mensaje', 'msg'];

  static ServiceException toServiceException(
    Object error, {
    String fallback = 'Error inesperado',
  }) {
    if (error is ServiceException) return error;

    if (error is Map) {
      for (final key in _messageKeys) {
        final value = error[key];
        if (value is String && value.trim().isNotEmpty) {
          return ServiceException(value);
        }
      }
    }

    return ServiceException(fallback);
  }
}
