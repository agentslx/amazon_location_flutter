/// Exception thrown when an Amazon Location Service API call fails.
class AmazonLocationException implements Exception {
  const AmazonLocationException({
    required this.statusCode,
    required this.message,
  });

  /// HTTP status code returned by the API.
  final int statusCode;

  /// Human-readable error message.
  final String message;

  @override
  String toString() =>
      'AmazonLocationException(statusCode: $statusCode, message: $message)';
}
