/// Exception thrown when Deepgram API requests fail
class DeepgramException implements Exception {
  final String message;
  final int? statusCode;

  DeepgramException(this.message, {this.statusCode});

  @override
  String toString() => 'DeepgramException: $message (Status: $statusCode)';
}
