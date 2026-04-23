import 'package:algonaid_mobail_app/core/errors/exception.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/course_local_stroage.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remote;
  final CourseLocalDataSourse local;

  const CoursesRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    return _fetchData(
      fetchRemote: () => remote.fetchCourses(),
      fetchLocal: () => local.getAllCourses(),
      cacheData: (courses) => local.saveCourses(courses),
    );
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getMyCourses() async {
    return _fetchData(
      fetchRemote: () => remote.fetchMyCourses(),
      fetchLocal: () => local.getMyCourses(),
      cacheData: (courses) => local.saveMyCourses(courses),
    );
  }
  @override
  Future<Either<Failure, CourseProgressEntity>> getCourseProgress(int courseId) async {
    return _fetchCourseProgress(
      fetchRemote: () => remote.fetchCourseProgress(courseId : courseId),
      fetchLocal: () => local.getMyCourseProgress(courseId: courseId),
      cacheData: (progress) => local.saveCourseProgress(progress, courseId),
    );
  }

  Future<Either<Failure, List<CourseEntity>>> _fetchData({
    required Future<List<CourseEntity>> Function() fetchRemote,
    required List<CourseEntity> Function() fetchLocal,
    required Future<void> Function(List<CourseEntity>) cacheData,
  }) async {
    try {
      final remoteCourses = await fetchRemote();

      await cacheData(remoteCourses);
   
      return Right(remoteCourses);
    } catch (e) {
      try {
        final localCourses = fetchLocal();

        if (localCourses.isNotEmpty) {
          return Right(localCourses);
        }
      } catch (cacheError) {}

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }

      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> enrollInCourse(int courseId) async {
    try {
      final result = await remote.enrollInCourse(courseId);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      }

      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }

      return Left(
        ServerFailure("حدث خطأ غير متوقع في الخادم، يرجى المحاولة لاحقاً"),
      );
    }
  }

 Future<Either<Failure, CourseProgressEntity>> _fetchCourseProgress({
    required Future<CourseProgressEntity> Function() fetchRemote,
    required CourseProgressEntity Function() fetchLocal,
    required Future<void> Function(CourseProgressEntity) cacheData,
  }) async {
    try {
      final remoteProgress = await fetchRemote();

      await cacheData(remoteProgress);

      return Right(remoteProgress);
    } catch (e) {
      try {
        final localProgress = fetchLocal();

        if (localProgress != null) {
          return Right(localProgress);
        }
      } catch (cacheError) {}

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }

      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}