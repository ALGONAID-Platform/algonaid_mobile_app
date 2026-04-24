// algonaid_mobail_app/lib/features/modules/domain/repositories/module_repository.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ModuleRepository {
  Future<Either<Failure, List<Module>>> getModulesByCourse(int courseId);
  Future<Either<Failure, LastAccessedModuleEntity?>> getLastAccessedModule();
  Future<Either<Failure, LastAccessedModuleEntity?>> getCachedLastAccessedModule();
}
