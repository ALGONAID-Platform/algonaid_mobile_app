import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

class GetLessonDetail {
  final LessonRepository _repository;

  const GetLessonDetail(this._repository);

  Future<Either<Failure, LessonDetail>> call(int lessonId) {
    return _repository.getLessonDetail(lessonId);
  }
}
