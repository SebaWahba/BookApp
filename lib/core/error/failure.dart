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

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
