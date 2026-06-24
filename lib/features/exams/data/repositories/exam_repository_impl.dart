import 'package:algonaid_mobile_app/core/errors/exceptions.dart';
import 'package:algonaid_mobile_app/core/errors/failure.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
import 'package:algonaid_mobile_app/core/network/dio_error_handler.dart';
import 'package:algonaid_mobile_app/features/exams/data/datasources/exam_local_data_source.dart';
import 'package:algonaid_mobile_app/features/exams/data/datasources/exam_remote_data_source.dart';
import 'package:algonaid_mobile_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobile_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobile_app/features/exams/domain/repositories/exam_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource remoteDataSource;
  final ExamLocalDataSource localDataSource;
  ExamRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Exam>> getExam(int examId) async {
    final localExam = await localDataSource.getCachedExam(examId);
    final isOffline = await hasNoInternet();

    if (isOffline) {
      if (localExam != null) {
        return Right(localExam);
      }
      return Left(
        ServerFailure(
          'لا يوجد اتصال بالإنترنت ولا توجد بيانات محفوظة لهذا الاختبار.',
        ),
      );
    }

    try {
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
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: getExam error for examId=$examId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      if (localExam != null) {
        return Right(localExam);
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      } else if (e is CacheException) {
        return Left(CacheFailure(e.message));
      }
      return Left(ServerFailure('تعذر تحميل الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamAttempt>> startExam(int examId) async {
    final isOffline = await hasNoInternet();

    if (isOffline) {
      final localExam = await localDataSource.getCachedExam(examId);
      if (localExam != null) {
        return Right(_buildOfflineAttempt(localExam));
      }
      return Left(
        ServerFailure(
          'لا يمكن بدء الاختبار بدون اتصال بالإنترنت لعدم توفر نسخة محفوظة.',
        ),
      );
    }

    try {
      final examAttempt = await remoteDataSource.startExam(examId);
      return Right(examAttempt);
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: startExam error for examId=$examId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      final localExam = await localDataSource.getCachedExam(examId);
      if (localExam != null) {
        return Right(_buildOfflineAttempt(localExam));
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('تعذر بدء الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> submitExam(
    int attemptId,
    Map<int, int> answers,
  ) async {
    try {
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
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: submitExam error for attemptId=$attemptId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure('تعذر تسليم الاختبار حالياً. حاول مرة أخرى.'));
    }
  }

  @override
  Future<Either<Failure, ExamResult>> getExamResult(int attemptId) async {
    try {
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
    } catch (e, stackTrace) {
      debugPrint(
        'ExamRepositoryImpl: getExamResult error for attemptId=$attemptId: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      final cachedResult = await localDataSource.getCachedExamResult(attemptId);
      if (cachedResult != null) {
        return Right(cachedResult);
      }
      if (e is DioException) {
        return Left(DioErrorHandler.handle(e));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
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

  ExamAttemptModel _buildOfflineAttempt(ExamModel exam) {
    return ExamAttemptModel(
      id: -exam.id,
      score: 0,
      status: 'OFFLINE',
      startedAt: DateTime.now(),
      studentId: 0,
      examId: exam.id,
      questions: exam.questions,
    );
  }
}
