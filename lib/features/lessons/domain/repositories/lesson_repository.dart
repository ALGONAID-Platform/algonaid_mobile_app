import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/paginated_lessons.dart';
import 'package:dartz/dartz.dart';

abstract class LessonRepository {
  Future<Either<Failure, PaginatedLessons>> getModuleLessons(int moduleId, {int page = 1, int? limit});
  Either<Failure, List<Lesson>> getCachedModuleLessons(int moduleId);
}
