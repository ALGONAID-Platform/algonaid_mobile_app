// algonaid_mobail_app/lib/features/modules/data/repositories/module_repository_impl.dart

import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/modules/data/datasources/module_remote_datasource.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';

class ModuleRepositoryImpl implements ModuleRepository {
  final ModuleRemoteDataSource remoteDataSource;

  ModuleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Module>>> getModulesByCourse(int courseId) async {
    try {
      final moduleModels = await remoteDataSource.getModulesByCourse(courseId);
      return Right(moduleModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
