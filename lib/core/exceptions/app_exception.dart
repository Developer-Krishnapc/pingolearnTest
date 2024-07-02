enum ErrorType {
  parsing,
  network,
  timeout,
  responseError,
  firebaseError,
  other,
}

class AppException implements Exception {
  AppException({required this.type, required this.message, this.trace});

  final ErrorType type;
  final String message;
  final StackTrace? trace;
}
