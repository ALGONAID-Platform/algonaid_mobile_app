import 'package:flutter/foundation.dart';
import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobile_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/paginated_lessons.dart';
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
  Future<Either<Failure, PaginatedLessons>> getModuleLessons(int moduleId, {int page = 1, int? limit}) async {
    final localModels = localDataSource.getLessons(moduleId);
    final isOffline = await hasNoInternet();

    if (isOffline) {
      if (localModels.isNotEmpty) {
        // Since we are offline, we can just return all local models and fake a single page of pagination
        final sorted = _sortLessons(localModels);
        return Right(PaginatedLessons(
            lessons: sorted,
            meta: PaginationMeta(
                total: sorted.length, page: 1, limit: sorted.length, totalPages: 1)));
      }
      return Left(
        ServerFailure(
          'لا يوجد اتصال بالإنترنت ولا توجد دروس محفوظة لهذه الوحدة.',
        ),
      );
    }

    try {
      final paginatedResult = await remoteDataSource.fetchLessonsByModule(
        moduleId,
        page: page,
        limit: limit,
      );
      final sortedRemoteModels = _sortLessons(paginatedResult.lessons);
      
      // Only cache first page or all of them depending on logic, here we can just save them
      if (page == 1) {
          await localDataSource.saveLessons(
            moduleId,
            sortedRemoteModels.map((e) => e as LessonModel).toList(),
          );
      }
      
      return Right(PaginatedLessons(lessons: sortedRemoteModels, meta: paginatedResult.meta));
    } catch (e) {
      if ((e is DioException || e is ServerException) &&
          localModels.isNotEmpty) {
        debugPrint('Failed to fetch lessons from remote, trying local...');
        final sorted = _sortLessons(localModels);
        return Right(PaginatedLessons(
            lessons: sorted,
            meta: PaginationMeta(
                total: sorted.length, page: 1, limit: sorted.length, totalPages: 1)));
      }

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(
        const ServerFailure('حدث خطأ غير متوقع أثناء تحميل الدروس'),
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

  @override
  Either<Failure, List<Lesson>> getCachedModuleLessons(int moduleId) {
    try {
      final localModels = localDataSource.getLessons(moduleId);
      if (localModels.isNotEmpty) {
        final sorted = _sortLessons(localModels);
        // We only return the first 10 lessons from cache to avoid jumping from 20 (cached) to 10 (remote)
        return Right(sorted.take(10).toList());
      }
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure("خطأ في قراءة الدروس المخزنة مؤقتاً"));
    }
  }
}
