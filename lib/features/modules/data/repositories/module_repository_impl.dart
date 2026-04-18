import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/modules/data/datasources/module_local_datasource.dart';
import 'package:algonaid_mobail_app/features/modules/data/datasources/module_remote_datasource.dart';
import 'package:algonaid_mobail_app/features/modules/data/models/module_model.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/domain/repositories/module_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ModuleRepositoryImpl implements ModuleRepository {
  final ModuleRemoteDataSource remoteDataSource;
  final ModuleLocalDataSource localDataSource;

  ModuleRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Module>>> getModulesByCourse(int courseId) async {
    try {
      final remoteModules = await remoteDataSource.getModulesByCourse(courseId);
      await localDataSource.saveModules(remoteModules.map((e) => e as ModuleModel).toList());
      return Right(remoteModules);
    } catch (e) {
      if (e is DioException || e is ServerException) {
        final localModules = localDataSource.getModules(courseId);
        if (localModules.isNotEmpty) {
          return Right(localModules);
        }
      }

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
