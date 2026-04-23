import 'package:algonaid_mobail_app/core/errors/exceptions.dart';
import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:algonaid_mobail_app/features/exams/data/datasources/exam_local_data_source.dart';
import 'package:algonaid_mobail_app/features/exams/data/datasources/exam_mock_data_source.dart';
import 'package:algonaid_mobail_app/features/exams/data/datasources/exam_remote_data_source.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/domain/repositories/exam_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class ExamRepositoryImpl implements ExamRepository {
  static const int mockExamId = 1;
  static const int mockAttemptId = 10001;

  final ExamRemoteDataSource remoteDataSource;
  final ExamLocalDataSource localDataSource;
  final ExamMockDataSource mockDataSource;

  ExamRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.mockDataSource,
  });

  @override
  Future<Either<Failure, Exam>> getExam(int examId) async {
    try {
      if (examId == mockExamId) {
        final mockExam = await mockDataSource.getExam();
        return Right(mockExam);
      }
      final remoteExam = await remoteDataSource.getExam(examId);
      try {
        await localDataSource.cacheExam(remoteExam);
      } catch (e, stackTrace) {
        debugPrint(
          'ExamRepositoryImpl: cacheExam failed for examId=$examId: $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return Right(remoteExam);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      final localExam = await localDataSource.getCachedExam(examId);
      if (localExam != null) {
        return Right(localExam);
      }
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: getExam unexpected error for examId=$examId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return Left(ServerFailure('تعذر تحميل الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamAttempt>> startExam(int examId) async {
    try {
      if (examId == mockExamId) {
        final mockAttempt = await mockDataSource.startExam();
        return Right(mockAttempt);
      }
      final examAttempt = await remoteDataSource.startExam(examId);
      return Right(examAttempt);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: startExam unexpected error for examId=$examId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return Left(ServerFailure('تعذر بدء الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> submitExam(
    int attemptId,
    Map<int, int> answers,
  ) async {
    try {
      if (attemptId == mockAttemptId) {
        final mockResult = await mockDataSource.submitExam(answers);
        try {
          await localDataSource.saveExamResult(mockResult);
        } catch (e, stackTrace) {
          debugPrint(
            'ExamRepositoryImpl: saveExamResult failed for mock attemptId=$attemptId: $e',
          );
          debugPrintStack(stackTrace: stackTrace);
        }
        return Right(mockResult);
      }
      await remoteDataSource.submitExam(attemptId, answers);
      final examResult = await remoteDataSource.getExamResult(attemptId);
      try {
        await localDataSource.saveExamResult(examResult);
      } catch (e, stackTrace) {
        debugPrint(
          'ExamRepositoryImpl: saveExamResult failed for attemptId=$attemptId: $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return Right(examResult);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('تعذر تسليم الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> getExamResult(int attemptId) async {
    try {
      if (attemptId == mockAttemptId) {
        final mockResult = await mockDataSource.getExamResult();
        return Right(mockResult);
      }
      final examResult = await remoteDataSource.getExamResult(attemptId);
      try {
        await localDataSource.saveExamResult(examResult);
      } catch (e, stackTrace) {
        debugPrint(
          'ExamRepositoryImpl: saveExamResult failed while fetching result for attemptId=$attemptId: $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return Right(examResult);
    } on ServerException catch (e) {
      final cachedResult = await localDataSource.getCachedExamResult(attemptId);
      if (cachedResult != null) {
        return Right(cachedResult);
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('تعذر تحميل نتيجة الاختبار حالياً.'));
    }
  }

  @override
  Future<void> saveExamProgress(int examId, Map<int, int> answers) async {
    await localDataSource.saveExamProgress(examId, answers);
  }

  @override
  Future<Map<int, int>?> getExamProgress(int examId) async {
    return await localDataSource.getExamProgress(examId);
  }
}
