// algonaid_mobail_app/lib/features/lessons/domain/usecases/get_lesson_detail.dart

import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/core/usecase/usecase.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:dartz/dartz.dart';

class GetLessonDetail extends UseCase<Lesson, int> {
  final LessonRepository repository;

  GetLessonDetail(this.repository);

  @override
  Future<Either<Failure, Lesson>> call(int lessonId) async {
    return await repository.getLessonDetail(lessonId);
  }
}
