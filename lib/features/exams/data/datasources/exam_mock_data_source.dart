import 'dart:convert';

import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';
import 'package:flutter/services.dart';

abstract class ExamMockDataSource {
  Future<ExamModel> getExam();
  Future<ExamAttemptModel> startExam();
  Future<ExamResultModel> submitExam(Map<int, int> answers);
  Future<ExamResultModel> getExamResult();
}

class ExamMockDataSourceImpl implements ExamMockDataSource {
  static const _mockExamAssetPath = 'assets/mock_data/exam_data.json';
  static const _mockExamId = 1;
  static const _mockAttemptId = 10001;

  ExamResultModel? _lastResult;

  @override
  Future<ExamModel> getExam() async {
    final decoded = await _loadMockExamJson();
    final examJson = decoded['exam'] as Map<String, dynamic>;

    final questionsJson =
        (examJson['questions'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList();



    final questions = <QuestionModel>[];

    for (var questionIndex = 0; questionIndex < questionsJson.length; questionIndex++) {
      final questionJson = questionsJson[questionIndex];
      final optionsJson =
          (questionJson['options'] as List<dynamic>? ?? const <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .toList();

      final options = <OptionModel>[];

      for (var optionIndex = 0; optionIndex < optionsJson.length; optionIndex++) {
        final optionJson = optionsJson[optionIndex];
        options.add(
          OptionModel(
            id: _optionId(questionIndex, optionIndex),
            text: optionJson['text'] as String? ?? '',
            isCorrect: optionJson['isCorrect'] as bool? ?? false,
            questionId: _questionId(questionIndex),
          ),
        );
      }

      questions.add(
        QuestionModel(
          id: _questionId(questionIndex),
          text: questionJson['text'] as String? ?? '',
          type: _normalizeQuestionType(questionJson['type'] as String?),
          points: 1,
          examId: _mockExamId,
          options: options,
          description: questionJson['description'] as String?,
          imageUrl: questionJson['imageUrl'] as String?,
          explanation: questionJson['explanation'] as String?,
        ),
      );
    }

    return ExamModel(
      id: _mockExamId,
      title: examJson['title'] as String? ?? 'اختبار تجريبي',
      description: examJson['subject'] as String? ?? 'اختبار تجريبي من ملف محلي',
      passingScore: 50,
      maxAttempts: 99,
      lessonId: 0,
      questions: questions,
    );
  }

  @override
  Future<ExamAttemptModel> startExam() async {
    final exam = await getExam();
    return ExamAttemptModel(
      id: _mockAttemptId,
      score: 0,
      status: 'IN_PROGRESS',
      startedAt: DateTime.now(),
      studentId: 0,
      examId: exam.id,
      questions: exam.questions,
      answers: const {},
    );
  }

  @override
  Future<ExamResultModel> submitExam(Map<int, int> answers) async {
    final exam = await getExam();
    var correctAnswers = 0;
    var totalScore = 0;

    for (final question in exam.questions) {
      final selectedOptionId = answers[question.id];
      final selectedOption = question.options.where((option) {
        return option.id == selectedOptionId;
      }).cast<OptionModel?>().firstWhere(
            (option) => option != null,
            orElse: () => null,
          );

      if (selectedOption?.isCorrect == true) {
        correctAnswers++;
        totalScore += question.points;
      }
    }

    final result = ExamResultModel(
      attemptId: _mockAttemptId,
      examId: exam.id,
      studentId: 0,
      score: totalScore,
      status: correctAnswers * 100 >= exam.questions.length * exam.passingScore
          ? 'PASSED'
          : 'FAILED',
      submittedAt: DateTime.now(),
      totalQuestions: exam.questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: exam.questions.length - correctAnswers,
      answers: Map<int, int>.from(answers),
    );

    _lastResult = result;
    return result;
  }

  @override
  Future<ExamResultModel> getExamResult() async {
    return _lastResult ?? submitExam(const {});
  }

  int _questionId(int questionIndex) => questionIndex + 1;

  int _optionId(int questionIndex, int optionIndex) =>
      ((questionIndex + 1) * 100) + optionIndex + 1;

  String _normalizeQuestionType(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'multiple_choice':
        return 'MULTIPLE_CHOICE';
      case 'true_false':
        return 'TRUE_FALSE';
      default:
        return 'MULTIPLE_CHOICE';
    }
  }

  Future<Map<String, dynamic>> _loadMockExamJson() async {
    try {
      final raw = await rootBundle.loadString(_mockExamAssetPath);
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return _embeddedMockExam;
    }
  }

  static const Map<String, dynamic> _embeddedMockExam = {
    'exam': {
      'id': 'exam_001',
      'title': 'اختبار تجريبي',
      'subject': 'اختبار محلي مؤقت للتجربة',
      'questions': [
        {
          'text': 'ما هو المتغير؟',
          'type': 'multiple_choice',
          'description': 'اختر الإجابة الصحيحة من الخيارات التالية.',
          'imageUrl': null,
          'options': [
            {'text': 'مكان لتخزين البيانات', 'isCorrect': true},
            {'text': 'نوع من أنواع الصور', 'isCorrect': false},
            {'text': 'أمر لإغلاق البرنامج', 'isCorrect': false},
            {'text': 'صفحة ويب', 'isCorrect': false},
          ],
          'explanation': 'المتغير هو مكان لتخزين البيانات داخل البرنامج.',
        },
        {
          'text': 'أي الخيارات التالية يمثل دالة؟',
          'type': 'multiple_choice',
          'description': 'اختر الأنسب.',
          'imageUrl': null,
          'options': [
            {'text': 'int x = 5;', 'isCorrect': false},
            {'text': 'print("Hello")', 'isCorrect': true},
            {'text': 'const value', 'isCorrect': false},
            {'text': 'class User {}', 'isCorrect': false},
          ],
          'explanation': 'استدعاء print يمثل دالة.',
        },
        {
          'text': 'ما الهدف من الشرط if؟',
          'type': 'multiple_choice',
          'description': 'اختر الإجابة الصحيحة.',
          'imageUrl': null,
          'options': [
            {'text': 'تكرار الأوامر دائماً', 'isCorrect': false},
            {'text': 'تنفيذ كود عند تحقق شرط', 'isCorrect': true},
            {'text': 'تعريف متغير جديد فقط', 'isCorrect': false},
            {'text': 'إنشاء ملف', 'isCorrect': false},
          ],
          'explanation': 'if تستخدم لتنفيذ كود بناءً على شرط.',
        },
      ],
    },
  };
}
