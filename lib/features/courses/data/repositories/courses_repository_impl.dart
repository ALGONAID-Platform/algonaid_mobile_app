import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobail_app/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  const CoursesRepositoryImpl(this._remote);

  final CoursesRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<CourseEntity>>> getCourses() async {
    try {
      final courses = await _remote.fetchCourses();

      return Right(courses);
    } catch (e) {
      if (e is DioException) {
        return left(DioErrorHandler.handle(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  // @override
  // Future<ContinueLearningCourse?> getContinueLearning() async {
  //   final model = await _remote.fetchContinueLearning();
  //   return model?.toEntity();
  // }
}
