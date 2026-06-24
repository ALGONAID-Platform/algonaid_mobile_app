import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobile_app/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedModulesUsecase {
  final ModuleRepository repository;

  GetCachedModulesUsecase(this.repository);

  Either<Failure, List<Module>> call(int courseId) {
    return repository.getCachedModulesByCourse(courseId);
  }
}
