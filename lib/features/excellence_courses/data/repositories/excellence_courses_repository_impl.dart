import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/data/datasources/excellence_courses_local_data_source.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/data/datasources/excellence_courses_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/data/models/excellence_course_model.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/repositories/excellence_courses_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ExcellenceCoursesRepositoryImpl implements ExcellenceCoursesRepository {
  final ExcellenceCoursesRemoteDataSource remote;
  final ExcellenceCoursesLocalDataSource local;

  const ExcellenceCoursesRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, List<ExcellenceCourseEntity>>> getExcellenceCourses() async {
    final isOffline = await hasNoInternet();

    if (isOffline) {
      try {
        final localCourses = await local.getExcellenceCourses();
        if (localCourses != null) {
          return Right(localCourses);
        }
      } catch (_) {}
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت ولا توجد بيانات محفوظة للتميز.'));
    }

    try {
      final courses = await remote.fetchExcellenceCourses();
      await local.saveExcellenceCourses(courses);
      return Right(courses);
    } catch (e) {
      try {
        final localCourses = await local.getExcellenceCourses();
        if (localCourses != null) {
          return Right(localCourses);
        }
      } catch (_) {}

      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<ExcellenceModuleEntity>>> getExcellenceModules(int courseId) async {
    final isOffline = await hasNoInternet();

    if (isOffline) {
      return Left(ServerFailure('لا يوجد اتصال بالإنترنت لعرض موديولات التميز.'));
    }

    try {
      final modules = await remote.fetchExcellenceModules(courseId);
      return Right(modules);
    } catch (e) {
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
