import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/core/userCases/no_param_use_case.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetCoursesUsecase extends UseCase<List<CourseEntity>> {
  GetCoursesUsecase({required this.repository});

  final CoursesRepository repository;

  @override
  Future<Either<Failure, List<CourseEntity>>> call() {
    return repository.getAllCourses();
  }
}
