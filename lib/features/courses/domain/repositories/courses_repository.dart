import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:dartz/dartz.dart';

/// عقد جلب بيانات الدورات (كتالوج، متابعة التعلم، …).
abstract class CoursesRepository {
  Future<Either<Failure, List<CourseEntity>>> getAllCourses();
  Future<Either<Failure, List<CourseEntity>>> getMyCourses();
}
