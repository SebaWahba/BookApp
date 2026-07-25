import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';

abstract class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}
