import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedLessonsUsecase {
  final LessonRepository repository;

  GetCachedLessonsUsecase(this.repository);

  Either<Failure, List<Lesson>> call(int moduleId) {
    return repository.getCachedModuleLessons(moduleId);
  }
}
