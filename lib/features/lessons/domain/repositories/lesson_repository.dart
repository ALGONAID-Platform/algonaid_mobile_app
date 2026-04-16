// algonaid_mobail_app/lib/features/lessons/domain/repositories/lesson_repository.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:dartz/dartz.dart';

abstract class LessonRepository {
  Future<Either<Failure, List<Lesson>>> getModuleLessons(int moduleId);
  Future<Either<Failure, Lesson>> getLessonDetail(int lessonId);
}
