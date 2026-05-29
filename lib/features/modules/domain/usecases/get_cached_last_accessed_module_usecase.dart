import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:algonaid_mobail_app/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedLastAccessedModuleUseCase {
  final ModuleRepository repository;

  GetCachedLastAccessedModuleUseCase({required this.repository});

  Future<Either<Failure, LastAccessedModuleEntity?>> call() async {
    return await repository.getCachedLastAccessedModule();
  }
}
