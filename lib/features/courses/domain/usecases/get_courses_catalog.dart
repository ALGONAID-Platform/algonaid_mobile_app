import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/userCases/no_param_use_case.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetCoursesCatalog extends UseCase<List<CourseEntity>> {
  GetCoursesCatalog(this._repository);

  final CoursesRepository _repository;

  @override
  Future<Either<Failure, List<CourseEntity>>> call() {
    return _repository.getCourses();
  }
}
