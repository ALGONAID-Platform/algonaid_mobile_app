import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/userCases/usecase.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';


class GetCourseProgressUsecase extends UseCase<CourseProgressEntity, GetCourseProgressParams> {
  GetCourseProgressUsecase({required this.repository});

  final CoursesRepository repository;

  @override
  Future<Either<Failure, CourseProgressEntity>> call(GetCourseProgressParams params) {
    return repository.getCourseProgress(params.courseId);
  }
}
class GetCourseProgressParams {
  final int courseId;

  GetCourseProgressParams({required this.courseId});
}