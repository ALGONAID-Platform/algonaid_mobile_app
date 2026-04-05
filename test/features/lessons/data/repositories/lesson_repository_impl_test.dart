import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_local_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/datasources/lesson_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_detail_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/lessons/data/repositories/lesson_repository_impl.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLessonRemoteDataSource implements LessonRemoteDataSource {
  final Future<List<LessonModel>> Function(int moduleId)
      fetchLessonsByModuleImpl;
  final Future<LessonDetailModel> Function(int lessonId)
      fetchLessonDetailImpl;

  FakeLessonRemoteDataSource({
    required this.fetchLessonsByModuleImpl,
    required this.fetchLessonDetailImpl,
  });

  @override
  Future<List<LessonModel>> fetchLessonsByModule(int moduleId) {
    return fetchLessonsByModuleImpl(moduleId);
  }

  @override
  Future<LessonDetailModel> fetchLessonDetail(int lessonId) {
    return fetchLessonDetailImpl(lessonId);
  }
}

class FakeLessonLocalDataSource implements LessonLocalDataSource {
  final Map<int, List<LessonModel>> _lessonsCache = {};
  final Map<int, LessonDetailModel> _lessonDetailCache = {};

  @override
  Future<void> cacheLessons(int moduleId, List<Lesson> lessons) async {
    _lessonsCache[moduleId] = lessons
        .map(
          (lesson) => lesson is LessonModel
              ? lesson
              : LessonModel(
                  id: lesson.id,
                  moduleId: lesson.moduleId,
                  title: lesson.title,
                  order: lesson.order,
                  description: lesson.description,
                  videoUrl: lesson.videoUrl,
                ),
        )
        .toList();
  }

  @override
  Future<List<LessonModel>> getCachedLessons(int moduleId) async {
    return _lessonsCache[moduleId] ?? <LessonModel>[];
  }

  @override
  Future<void> cacheLessonDetail(LessonDetail lesson) async {
    _lessonDetailCache[lesson.id] = lesson is LessonDetailModel
        ? lesson
        : LessonDetailModel(
            id: lesson.id,
            moduleId: lesson.moduleId,
            title: lesson.title,
            order: lesson.order,
            description: lesson.description,
            content: lesson.content,
            videoUrl: lesson.videoUrl,
            pdfUrl: lesson.pdfUrl,
            exam: lesson.exam,
          );
  }

  @override
  Future<LessonDetailModel?> getCachedLessonDetail(int lessonId) async {
    return _lessonDetailCache[lessonId];
  }
}

DioException _dioException() {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    type: DioExceptionType.connectionError,
    error: 'connection error',
  );
}

void main() {
  group('LessonRepositoryImpl', () {
    test('getLessonsByModule returns Right on success', () async {
      final dataSource = FakeLessonRemoteDataSource(
        fetchLessonsByModuleImpl: (moduleId) async => [
          const LessonModel(
            id: 1,
            moduleId: 10,
            title: 'Lesson',
            order: 1,
          ),
        ],
        fetchLessonDetailImpl: (lessonId) async => const LessonDetailModel(
          id: 1,
          moduleId: 10,
          title: 'Detail',
          order: 1,
        ),
      );
      final localDataSource = FakeLessonLocalDataSource();

      final repo = LessonRepositoryImpl(dataSource, localDataSource);
      final result = await repo.getLessonsByModule(10);

      expect(result.isRight(), isTrue);
    });

    test('getLessonsByModule returns Left on DioException', () async {
      final dataSource = FakeLessonRemoteDataSource(
        fetchLessonsByModuleImpl: (moduleId) async {
          throw _dioException();
        },
        fetchLessonDetailImpl: (lessonId) async => const LessonDetailModel(
          id: 1,
          moduleId: 10,
          title: 'Detail',
          order: 1,
        ),
      );
      final localDataSource = FakeLessonLocalDataSource();

      final repo = LessonRepositoryImpl(dataSource, localDataSource);
      final result = await repo.getLessonsByModule(10);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (_) => null), isA<Failure>());
    });

    test('getLessonsByModule returns Left on ServerException', () async {
      final dataSource = FakeLessonRemoteDataSource(
        fetchLessonsByModuleImpl: (moduleId) async {
          throw ServerException(message: 'bad format');
        },
        fetchLessonDetailImpl: (lessonId) async => const LessonDetailModel(
          id: 1,
          moduleId: 10,
          title: 'Detail',
          order: 1,
        ),
      );
      final localDataSource = FakeLessonLocalDataSource();

      final repo = LessonRepositoryImpl(dataSource, localDataSource);
      final result = await repo.getLessonsByModule(10);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (_) => null), isA<Failure>());
    });

    test('getLessonDetail returns Left on generic Exception', () async {
      final dataSource = FakeLessonRemoteDataSource(
        fetchLessonsByModuleImpl: (moduleId) async => [
          const LessonModel(
            id: 1,
            moduleId: 10,
            title: 'Lesson',
            order: 1,
          ),
        ],
        fetchLessonDetailImpl: (lessonId) async {
          throw Exception('unexpected');
        },
      );
      final localDataSource = FakeLessonLocalDataSource();

      final repo = LessonRepositoryImpl(dataSource, localDataSource);
      final result = await repo.getLessonDetail(1);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (_) => null), isA<Failure>());
    });

    test('getLessonDetail returns Right on success', () async {
      final dataSource = FakeLessonRemoteDataSource(
        fetchLessonsByModuleImpl: (moduleId) async => [
          const LessonModel(
            id: 1,
            moduleId: 10,
            title: 'Lesson',
            order: 1,
          ),
        ],
        fetchLessonDetailImpl: (lessonId) async => const LessonDetailModel(
          id: 1,
          moduleId: 10,
          title: 'Detail',
          order: 1,
        ),
      );
      final localDataSource = FakeLessonLocalDataSource();

      final repo = LessonRepositoryImpl(dataSource, localDataSource);
      final result = await repo.getLessonDetail(1);

      expect(result, isA<Right<Failure, LessonDetailModel>>());
      expect(result.isRight(), isTrue);
    });
  });
}
