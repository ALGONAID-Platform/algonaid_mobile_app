import 'dart:convert';

import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ExamLocalDataSource {
  Future<void> saveExamProgress(String examId, Map<String, String> answers);
  Future<Map<String, String>?> getExamProgress(String examId);
  Future<void> saveExam(ExamModel exam);
  Future<ExamModel?> getExam(String examId);
  Future<void> saveExamResult(ExamResultModel result);
  Future<ExamResultModel?> getExamResult(String attemptId);
}

class ExamLocalDataSourceImpl implements ExamLocalDataSource {
  @override
  Future<Map<String, String>?> getExamProgress(String examId) async {
    final box = Hive.box<String>(
      AppConstants.boxReadingProgress,
    ); // Using a string box for JSON encoded map
    final String? progressJson = box.get(examId);
    if (progressJson != null) {
      return Map<String, String>.from(jsonDecode(progressJson));
    }
    return null;
  }

  @override
  Future<void> saveExamProgress(
    String examId,
    Map<String, String> answers,
  ) async {
    final box = Hive.box<String>(AppConstants.boxReadingProgress);
    await box.put(examId, jsonEncode(answers));
  }

  @override
  Future<ExamModel?> getExam(String examId) async {
    final box = Hive.box<ExamModel>(AppConstants.boxExams);
    return box.get(examId);
  }

  @override
  Future<void> saveExam(ExamModel exam) async {
    final box = Hive.box<ExamModel>(AppConstants.boxExams);
    await box.put(exam.id, exam);
  }

  @override
  Future<ExamResultModel?> getExamResult(String attemptId) async {
    final box = Hive.box<ExamResultModel>(AppConstants.boxExamResults);
    return box.get(attemptId);
  }

  @override
  Future<void> saveExamResult(ExamResultModel result) async {
    final box = Hive.box<ExamResultModel>(AppConstants.boxExamResults);
    await box.put(
      result.examId,
      result,
    ); // Assuming examId is unique for result, or attemptId
  }
}

abstract class ExamRemoteDataSource {
  Future<Exam> getExam(String examId);
  Future<String> startExam(String examId);
  Future<ExamResult> submitExam(String attemptId, Map<String, String> answers);
  Future<ExamResult> getResult(String attemptId);
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final ApiService _apiService;

  ExamRemoteDataSourceImpl(this._apiService);

  @override
  Future<Exam> getExam(String examId) async {
    final response = await _apiService.get(endpoint: '/exams/$examId');
    return ExamModel.fromJson(response);
  }

  @override
  Future<String> startExam(String examId) async {
    final response = await _apiService.post(
      endpoint: '/exams/$examId/start',
      data: {},
    );
    return response['attemptId'] as String;
  }

  @override
  Future<ExamResult> submitExam(
    String attemptId,
    Map<String, String> answers,
  ) async {
    final submissionData = {
      'answers': answers.entries
          .map(
            (entry) => {
              'questionId': entry.key,
              'selectedOptionId': entry.value,
            },
          )
          .toList(),
    };
    final response = await _apiService.post(
      endpoint: '/exams/attempts/$attemptId/submit',
      data: submissionData,
    );
    return ExamResultModel.fromJson(response);
  }

  @override
  Future<ExamResult> getResult(String attemptId) async {
    final response = await _apiService.get(
      endpoint: '/exams/attempts/$attemptId/result',
    );
    return ExamResultModel.fromJson(response);
  }
}
