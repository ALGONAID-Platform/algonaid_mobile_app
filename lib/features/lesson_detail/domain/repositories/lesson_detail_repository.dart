import 'package:algonaid/core/errors/failure.dart';
import 'package:algonaid/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:dartz/dartz.dart';

abstract class LessonDetailRepository {
  Future<Either<Failure, LessonDetail>> getLessonDetail(int lessonId);
  Future<Either<Failure, void>> updateLessonProgress(int lessonId, bool isCompleted);
}
