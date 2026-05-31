import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:dartz/dartz.dart';

abstract class LessonDetailRepository {
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId);
  Future<Either<Failure, void>> updateLessonProgress(int lessonId, bool isCompleted);
}
