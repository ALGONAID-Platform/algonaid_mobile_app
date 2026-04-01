import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class LessonRepository {
  Future<Either<Failure, List<Lesson>>> getLessonsByModule(int moduleId);
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId);
}
