import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetLastAccessedModuleUseCase {
  final ModuleRepository repository;

  GetLastAccessedModuleUseCase({required this.repository});

  Future<Either<Failure, LastAccessedModuleEntity?>> call() async {
    return await repository.getLastAccessedModule();
  }
}
