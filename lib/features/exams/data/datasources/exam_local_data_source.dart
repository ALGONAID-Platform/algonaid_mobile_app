import 'dart:convert';

import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ExamLocalDataSource {
  Future<void> cacheExam(ExamModel exam);
  Future<ExamModel?> getCachedExam(int examId);
  Future<void> saveExamResult(ExamResultModel result);
  Future<ExamResultModel?> getCachedExamResult(int attemptId);
  Future<void> saveExamProgress(int examId, Map<int, int> answers);
  Future<Map<int, int>?> getExamProgress(int examId);
  Future<void> clearExamProgress(int examId);
}

class ExamLocalDataSourceImpl implements ExamLocalDataSource {
  Future<Box<T>> _openBoxSafely<T>(String name) async {
    try {
      if (Hive.isBoxOpen(name)) {
        return Hive.box<T>(name);
      }
      return await Hive.openBox<T>(name);
    } catch (_) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).close();
      }
      await Hive.deleteBoxFromDisk(name);
      return Hive.openBox<T>(name);
    }
  }

  Future<Box<ExamModel>> _examBox() async {
    return _openBoxSafely<ExamModel>(AppConstants.boxExams);
  }

  Future<Box<ExamResultModel>> _examResultBox() async {
    return _openBoxSafely<ExamResultModel>(AppConstants.boxExamResults);
  }

  Future<Box<String>> _progressBox() async {
    return _openBoxSafely<String>(AppConstants.boxReadingProgress);
  }

  @override
  Future<void> cacheExam(ExamModel exam) async {
    final box = await _examBox();
    await box.put(exam.id, exam);
  }

  @override
  Future<ExamModel?> getCachedExam(int examId) async {
    final box = await _examBox();
    return box.get(examId);
  }

  @override
  Future<void> saveExamResult(ExamResultModel result) async {
    final box = await _examResultBox();
    await box.put(result.attemptId, result);
  }

  @override
  Future<ExamResultModel?> getCachedExamResult(int attemptId) async {
    final box = await _examResultBox();
    return box.get(attemptId);
  }

  @override
  Future<void> saveExamProgress(int examId, Map<int, int> answers) async {
    final box = await _progressBox();
    final encoded = answers.map(
      (questionId, optionId) => MapEntry(questionId.toString(), optionId),
    );
    await box.put(examId.toString(), jsonEncode(encoded));
  }

  @override
  Future<Map<int, int>?> getExamProgress(int examId) async {
    final box = await _progressBox();
    final raw = box.get(examId.toString());
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (questionId, optionId) =>
          MapEntry(int.parse(questionId), (optionId as num).toInt()),
    );
  }

  @override
  Future<void> clearExamProgress(int examId) async {
    final box = await _progressBox();
    await box.delete(examId.toString());
  }
}
