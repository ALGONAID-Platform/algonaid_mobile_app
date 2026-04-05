import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'dart:async';

import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/check_internet.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource _remote;
  final LessonLocalDataSource _local;

  const LessonRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, List<Lesson>>> getLessonsByModule(int moduleId) async {
    try {
      final cached = await _local.getCachedLessons(moduleId);
      if (cached.isNotEmpty) {
        _refreshLessonsInBackground(moduleId);
        return Right(cached);
      }

      if (await hasNoInternet()) {
        return left(ServerFailure('لا يوجد اتصال بالإنترنت'));
      }

      final lessons = await _remote.fetchLessonsByModule(moduleId);
      await _local.cacheLessons(moduleId, lessons);
      return Right(lessons);
    } catch (e) {
      final cached = await _local.getCachedLessons(moduleId);
      if (cached.isNotEmpty) {
        return Right(cached);
      }
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
      final cached = await _local.getCachedLessonDetail(lessonId);
      if (cached != null) {
        _refreshLessonDetailInBackground(lessonId);
        return Right(cached);
      }

      if (await hasNoInternet()) {
        return left(ServerFailure('لا يوجد اتصال بالإنترنت'));
      }
      final lesson = await _remote.fetchLessonDetail(lessonId);
      await _local.cacheLessonDetail(lesson);
      return Right(lesson);
    } catch (e) {
      final cached = await _local.getCachedLessonDetail(lessonId);
      if (cached != null) {
        return Right(cached);
      }
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      if (e is ServerException) {
        return left(ServerFailure(e.message));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  void _refreshLessonsInBackground(int moduleId) {
    unawaited(() async {
      if (await hasNoInternet()) return;
      final lessons = await _remote.fetchLessonsByModule(moduleId);
      await _local.cacheLessons(moduleId, lessons);
    }());
  }

  void _refreshLessonDetailInBackground(int lessonId) {
    unawaited(() async {
      if (await hasNoInternet()) return;
      final lesson = await _remote.fetchLessonDetail(lessonId);
      await _local.cacheLessonDetail(lesson);
    }());
  }
}
