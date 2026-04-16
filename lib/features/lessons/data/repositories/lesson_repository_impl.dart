// algonaid_mobail_app/lib/features/lessons/data/repositories/lesson_repository_impl.dart

import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_datasource.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Lesson>> getLessonDetail(int lessonId) async {
    try {
      final lessonModel = await remoteDataSource.getLessonDetail(lessonId);
      return Right(lessonModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getModuleLessons(int moduleId) async {
    try {
      final lessonModels = await remoteDataSource.getModuleLessons(moduleId);
      return Right(lessonModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
