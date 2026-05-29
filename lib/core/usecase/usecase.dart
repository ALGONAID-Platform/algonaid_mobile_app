// algonaid_mobail_app/lib/core/usecase/usecase.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
