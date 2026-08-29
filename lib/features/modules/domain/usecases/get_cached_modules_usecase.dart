import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/modules/domain/entities/module.dart';
import 'package:algonaid/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedModulesUsecase {
  final ModuleRepository repository;

  GetCachedModulesUsecase(this.repository);

  Either<Failure, List<Module>> call(int courseId) {
    return repository.getCachedModulesByCourse(courseId);
  }
}
