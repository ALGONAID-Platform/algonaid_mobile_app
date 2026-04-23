// algonaid_mobail_app/lib/features/exams/domain/repositories/exam_repository.dart
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:dartz/dartz.dart';

abstract class ExamRepository {
  Future<Either<Failure, Exam>> getExam(int examId);
  Future<Either<Failure, ExamResult>> getExamResult(int attemptId);
  Future<Either<Failure, ExamAttempt>> startExam(int examId);
  Future<Either<Failure, ExamResult>> submitExam(
    int attemptId,
    Map<int, int> answers,
  );
  Future<void> saveExamProgress(int examId, Map<int, int> answers);
  Future<Map<int, int>?> getExamProgress(int examId);
}
