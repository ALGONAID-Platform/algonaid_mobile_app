import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/usecase/usecase.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_grades.dart';
import 'package:algonaid_mobile_app/features/courses/domain/repositories/courses_repository.dart';
import 'package:dartz/dartz.dart';

class GetCourseGrades implements UseCase<CourseGrades, int> {
  final CoursesRepository repository;

  GetCourseGrades(this.repository);

  @override
  Future<Either<Failure, CourseGrades>> call(int courseId) async {
    return await repository.getCourseGrades(courseId);
  }
}
