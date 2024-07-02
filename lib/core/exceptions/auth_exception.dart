sealed class AuthException implements Exception {}

class AccessTokenException extends AuthException {}

class RefreshTokenException extends AuthException {}

class UnauthorizedException extends AuthException {}
