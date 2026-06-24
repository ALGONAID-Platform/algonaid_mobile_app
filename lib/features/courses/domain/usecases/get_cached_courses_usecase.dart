import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobile_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedCoursesUsecase {
  final CoursesRepository repository;

  GetCachedCoursesUsecase({required this.repository});

  Either<Failure, List<CourseEntity>> call() {
    return repository.getCachedAllCourses();
  }
}
