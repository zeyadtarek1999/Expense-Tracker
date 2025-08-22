abstract class Failure {
  final String massage;

  const Failure(this.massage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.massage);
}

class CacheFailure extends Failure {
  CacheFailure(super.massage);
}
