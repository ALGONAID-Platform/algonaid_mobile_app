// algonaid/lib/core/usecase/usecase.dart

import 'package:algonaid/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
