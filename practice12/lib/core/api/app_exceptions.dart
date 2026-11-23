sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoConnectionException extends AppException {
  const NoConnectionException() : super('No connection');
}

class ServerException extends AppException {
  const ServerException(this.statusCode) : super('Server error');

  final int statusCode;
}

class BadDataException extends AppException {
  const BadDataException() : super('Bad data');
}
