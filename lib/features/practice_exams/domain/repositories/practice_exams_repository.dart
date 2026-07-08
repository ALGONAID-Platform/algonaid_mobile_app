import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/features/practice_exams/domain/entities/practice_exam_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PracticeExamsRepository {
  Future<Either<Failure, List<PracticeExamEntity>>> getPracticeExams(int courseId);
}
