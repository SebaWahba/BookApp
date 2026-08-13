abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class RateLimitFailure extends Failure {
  RateLimitFailure(super.message);
}

/// User-supplied input was rejected (a wrong verification code, a value the
/// server refused, ...).
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

/// A time-bound token, code or challenge is no longer accepted.
class ExpiredFailure extends Failure {
  ExpiredFailure(super.message);
}

/// The action needs an authenticated session, or a more recent one than we
/// currently hold.
class AuthSessionFailure extends Failure {
  AuthSessionFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
