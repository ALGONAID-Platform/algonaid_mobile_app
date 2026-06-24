import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class GetCachedLessonsUsecase {
  final LessonRepository repository;

  GetCachedLessonsUsecase(this.repository);

  Either<Failure, List<Lesson>> call(int moduleId) {
    return repository.getCachedModuleLessons(moduleId);
  }
}
