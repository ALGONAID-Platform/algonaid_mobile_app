import 'package:flutter/foundation.dart';
import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;
  final LessonLocalDataSource localDataSource;

  LessonRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Lesson>>> getModuleLessons(int moduleId) async {
    try {
      final remoteModels = await remoteDataSource.fetchLessonsByModule(moduleId);
      await localDataSource.saveLessons(remoteModels.map((e) => e as LessonModel).toList());
      return Right(remoteModels);
    } catch (e) {
      if (e is DioException || e is ServerException) {
        debugPrint('Failed to fetch lessons from remote, trying local...');
        final localModels = localDataSource.getLessons(moduleId);
        if (localModels.isNotEmpty) {
          return Right(localModels);
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

  @override
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId) async {
    try {
      final LessonDetailModel model =
          await remoteDataSource.fetchLessonDetail(lessonId);

      final entity = model.toEntity();

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(DioErrorHandler.handle(e));
    }
  }
}