import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Lesson>>> getModuleLessons(int moduleId) async {
    try {
      final models = await remoteDataSource.fetchLessonsByModule(moduleId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(DioErrorHandler.handle(e));
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

  @override
  Future<Either<Failure, void>> updateLessonProgress(int lessonId, bool isCompleted) async {
    try {
      await remoteDataSource.updateLessonProgress(lessonId, isCompleted);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(DioErrorHandler.handle(e));
    }
  }
}