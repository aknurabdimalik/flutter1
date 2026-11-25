sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NoConnectionException extends ApiException {
  const NoConnectionException() : super('No connection');
}

class NotFoundException extends ApiException {
  const NotFoundException() : super('Not found');
}

class ServerException extends ApiException {
  const ServerException(this.statusCode) : super('Server error');

  final int statusCode;
}

class BadResponseException extends ApiException {
  const BadResponseException(super.message);
}
