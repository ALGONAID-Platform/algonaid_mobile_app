import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource _remote;

  const LessonRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Lesson>>> getLessonsByModule(int moduleId) async {
    try {
      final lessons = await _remote.fetchLessonsByModule(moduleId);
      return Right(lessons);
    } catch (e) {
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      if (e is ServerException) {
        return left(ServerFailure(e.message));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId) async {
    try {
      final lesson = await _remote.fetchLessonDetail(lessonId);
      return Right(lesson);
    } catch (e) {
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      if (e is ServerException) {
        return left(ServerFailure(e.message));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
