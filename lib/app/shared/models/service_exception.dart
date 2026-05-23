/// Typed error used across the data layer.
///
/// Datasources translate any low-level failure (storage, parsing, future
/// network calls) into a [ServiceException] so the presentation layer only ever
/// has to deal with a single, predictable error type.
class ServiceException implements Exception {
  final String message;
  final int? statusCode;

  ServiceException(this.message, {this.statusCode});

  @override
  String toString() => 'ServiceException(${statusCode ?? '-'}): $message';
}
