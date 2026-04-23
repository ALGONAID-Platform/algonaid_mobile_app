import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/domain/usecases/exam_usecases.dart';

/// State for exam loading
enum ExamState { initial, loading, loaded, error }

/// Provider for managing exam state
class ExamProvider extends ChangeNotifier {
  ExamProvider({
    GetExamUseCase? getExamUseCase,
    StartExamUseCase? startExamUseCase,
    SubmitExamUseCase? submitExamUseCase,
    SaveExamProgressUseCase? saveExamProgressUseCase,
    GetExamProgressUseCase? getExamProgressUseCase,
    GetExamResultUseCase? getExamResultUseCase,
  }) : _getExamUseCase = getExamUseCase ?? getIt<GetExamUseCase>(),
       _startExamUseCase = startExamUseCase ?? getIt<StartExamUseCase>(),
       _submitExamUseCase = submitExamUseCase ?? getIt<SubmitExamUseCase>(),
       _saveProgressUseCase =
           saveExamProgressUseCase ?? getIt<SaveExamProgressUseCase>(),
       _getProgressUseCase =
           getExamProgressUseCase ?? getIt<GetExamProgressUseCase>(),
       _getExamResultUseCase =
           getExamResultUseCase ?? getIt<GetExamResultUseCase>();

  final GetExamUseCase _getExamUseCase;
  final StartExamUseCase _startExamUseCase;
  final SaveExamProgressUseCase _saveProgressUseCase;
  final GetExamProgressUseCase _getProgressUseCase;
  final SubmitExamUseCase _submitExamUseCase;
  final GetExamResultUseCase _getExamResultUseCase;

  // State variables
  ExamState _state = ExamState.initial;
  Exam? _exam;
  String? _error;
  int _currentQuestionIndex = 0;
  final Map<int, int> _answers = {};
  List<Question> _questions = const [];
  int? _attemptId;
  bool _isSubmitted = false;
  ExamResult? _result;

  // Getters
  ExamState get state => _state;
  Exam? get exam => _exam;
  String? get error => _error;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, int> get answers => _answers;
  int? get attemptId => _attemptId;
  bool get isSubmitted => _isSubmitted;
  ExamResult? get result => _result;

  Question? get currentQuestion {
    if (_questions.isNotEmpty && _currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return null;
  }

  Question? questionAt(int index) {
    if (index < 0 || index >= _questions.length) {
      return null;
    }
    return _questions[index];
  }

  int get totalQuestions => _questions.length;
  int get answeredQuestions => _answers.length;
  int get remainingQuestions => totalQuestions - answeredQuestions;

  /// Load exam data
  Future<void> loadExam(int examId) async {
    // 1. Check if already loading or already loaded for same ID to prevent redundant calls
    if (_state == ExamState.loading) {
      debugPrint(
        'ExamProvider: loadExam skipped because state is already loading',
      );
      return;
    }
    if (_exam?.id == examId && _state == ExamState.loaded) {
      debugPrint(
        'ExamProvider: loadExam skipped because examId=$examId is already loaded',
      );
      return;
    }

    debugPrint('ExamProvider: loadExam started for examId: $examId');

    _state = ExamState.loading;
    _error = null;
    _exam = null;
    _currentQuestionIndex = 0;
    _questions = const [];
    _attemptId = null;
    _isSubmitted = false;
    _result = null;
    _answers.clear();
    notifyListeners();

    try {
      // 2. Fetch Exam Details
      final examResult = await _getExamUseCase.call(examId);

      bool hasError = false;
      examResult.fold(
        (failure) {
          debugPrint(
            'ExamProvider: getExam FAILED for examId=$examId: ${failure.message}',
          );
          _state = ExamState.error;
          _error = failure.message;
          hasError = true;
        },
        (examData) {
          debugPrint(
            'ExamProvider: getExam succeeded for examId=$examId, '
            'title=${examData.title}, questions=${examData.questions.length}',
          );
          _exam = examData;
          _questions = examData.questions;
        },
      );

      if (hasError) {
        notifyListeners();
        return;
      }

      if (_questions.isEmpty) {
        debugPrint(
          'ExamProvider: examId=$examId has no questions after getExam/startExam',
        );
        _state = ExamState.error;
        _error = 'هذا الاختبار لا يحتوي على أسئلة حالياً.';
        notifyListeners();
        return;
      }

      // 3. Start Exam Attempt
      debugPrint('ExamProvider: Calling _startExamUseCase');
      final startResult = await _startExamUseCase.call(examId);

      startResult.fold(
        (failure) {
          debugPrint(
            'ExamProvider: _startExamUseCase FAILED: ${failure.message}',
          );
          _state = ExamState.error;
          _error = failure.message;
          hasError = true;
        },
        (attempt) {
          _attemptId = attempt.id;
          if (attempt.questions.isNotEmpty) {
            _questions = attempt.questions;
          }
          debugPrint('ExamProvider: Attempt started with ID: ${_attemptId}');
        },
      );

      if (hasError) {
        notifyListeners();
        return;
      }

      // 4. Load Saved Progress
      final savedProgress = await _getProgressUseCase.call(examId);
      if (savedProgress != null) {
        debugPrint(
          'ExamProvider: restored saved progress for examId=$examId, '
          'answers=${savedProgress.length}',
        );
        _answers.addAll(savedProgress);
      } else {
        debugPrint('ExamProvider: no saved progress found for examId=$examId');
      }

      _state = ExamState.loaded;
      debugPrint(
        'ExamProvider: Successfully LOADED. Questions: ${_questions.length}',
      );
    } catch (e) {
      debugPrint('ExamProvider: Unexpected error: $e');
      _state = ExamState.error;
      _error = 'تعذر تحميل الاختبار حالياً. حاول مرة أخرى.';
    }

    // Final notification to update UI
    notifyListeners();
  }

  /// Select an answer for the current question
  Future<void> selectAnswer(int optionId) async {
    if (currentQuestion != null) {
      _answers[currentQuestion!.id] = optionId;

      // Auto-save progress
      if (_exam != null) {
        await _saveProgressUseCase.call(_exam!.id, _answers);
      }

      notifyListeners();
    }
  }

  /// Move to next question
  void nextQuestion() {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Move to previous question
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Jump to specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  /// Submit exam
  Future<void> submitExam() async {
    if (_exam == null || _attemptId == null) return;

    _state = ExamState.loading;
    notifyListeners();

    final result = await _submitExamUseCase.call(_attemptId!, _answers);

    await result.fold(
      (failure) {
        _state = ExamState.error;
        _error = failure.message;
      },
      (examResult) async {
        _result = examResult;
        _isSubmitted = true;
        _state = ExamState.loaded;
        _error = null;
        try {
          final fetchedResult = await _getExamResultUseCase.call(_attemptId!);
          fetchedResult.fold((_) {}, (latestResult) => _result = latestResult);
        } catch (_) {}
        await _saveProgressUseCase.call(_exam!.id, <int, int>{});
      },
    );
    notifyListeners();
  }

  /// Reset exam
  void resetExam() {
    _state = ExamState.initial;
    _exam = null;
    _error = null;
    _currentQuestionIndex = 0;
    _answers.clear();
    _questions = const [];
    _attemptId = null;
    _isSubmitted = false;
    _result = null;
    notifyListeners();
  }

  /// Check if current question is answered
  bool isCurrentQuestionAnswered() {
    if (currentQuestion == null) return false;
    return _answers.containsKey(currentQuestion!.id);
  }

  /// Get user's answer for current question
  int? getUserAnswerForCurrentQuestion() {
    if (currentQuestion == null) return null;
    return _answers[currentQuestion!.id];
  }
}
