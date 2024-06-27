sealed class NetworkException implements Exception {}

class NoInternetException extends NetworkException {}

class ConnectionException extends NetworkException {}

class TimeoutException extends NetworkException {}

class CancelRequestException extends NetworkException {}

class BadResponseException extends NetworkException {}

class BadCertificateException extends NetworkException {}

class UnknownException extends NetworkException {}
