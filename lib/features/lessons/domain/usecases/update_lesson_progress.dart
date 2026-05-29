import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateLessonProgress {
  final LessonRepository repository;

  UpdateLessonProgress(this.repository);

  Future<Either<Failure, void>> call({
    required int lessonId,
    required bool isCompleted,
  }) async {
    return await repository.updateLessonProgress(lessonId, isCompleted);
  }
}
