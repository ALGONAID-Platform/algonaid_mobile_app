import 'package:flutter/foundation.dart';
import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobile_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;
  final LessonLocalDataSource localDataSource;

  LessonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Lesson>>> getModuleLessons(int moduleId) async {
    final localModels = localDataSource.getLessons(moduleId);
    final isOffline = await hasNoInternet();

    if (isOffline) {
      if (localModels.isNotEmpty) {
        return Right(localModels);
      }
      return Left(
        ServerFailure(
          'لا يوجد اتصال بالإنترنت ولا توجد دروس محفوظة لهذه الوحدة.',
        ),
      );
    }

    try {
      final remoteModels = await remoteDataSource.fetchLessonsByModule(
        moduleId,
      );
      final sortedRemoteModels = _sortLessons(remoteModels);
      await localDataSource.saveLessons(
        moduleId,
        sortedRemoteModels.map((e) => e as LessonModel).toList(),
      );
      return Right(sortedRemoteModels);
    } catch (e) {
      if ((e is DioException || e is ServerException) &&
          localModels.isNotEmpty) {
        debugPrint('Failed to fetch lessons from remote, trying local...');
        return Right(_sortLessons(localModels));
      }

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(
        ServerFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  List<Lesson> _sortLessons(List<Lesson> lessons) {
    final sortedLessons = [...lessons];
    sortedLessons.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.id.compareTo(b.id);
    });
    return sortedLessons;
  }
}
