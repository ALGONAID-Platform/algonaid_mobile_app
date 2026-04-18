import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:dartz/dartz.dart';

abstract class ExamRepository {
  Future<Either<Failure, Exam>> getExam(String examId);
  Future<String> startExam(String examId);
  Future<void> saveExamProgress(String examId, Map<String, String> answers);
  Future<Map<String, String>?> getExamProgress(String examId);
  Future<Either<Failure, ExamResult>> submitExam(String attemptId, Map<String, String> answers);
  Future<Either<Failure, ExamResult>> getExamResult(String attemptId);
}