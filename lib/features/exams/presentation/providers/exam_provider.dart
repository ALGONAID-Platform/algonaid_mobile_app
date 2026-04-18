import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/domain/usecases/exam_usecases.dart';

/// State for exam loading
enum ExamState { initial, loading, loaded, error }

/// Provider for managing exam state
class ExamProvider extends ChangeNotifier {
  final GetExamUseCase _getExamUseCase = getIt<GetExamUseCase>();
  final SaveExamProgressUseCase _saveProgressUseCase = getIt<SaveExamProgressUseCase>();
  final GetExamProgressUseCase _getProgressUseCase = getIt<GetExamProgressUseCase>();
  final SubmitExamUseCase _submitExamUseCase = getIt<SubmitExamUseCase>();

  // State variables
  ExamState _state = ExamState.initial;
  Exam? _exam;
  String? _error;
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};
  bool _isSubmitted = false;
  ExamResult? _result;

  // Getters
  ExamState get state => _state;
  Exam? get exam => _exam;
  String? get error => _error;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<String, String> get answers => _answers;
  bool get isSubmitted => _isSubmitted;
  ExamResult? get result => _result;

  Question? get currentQuestion {
    if (_exam != null && _currentQuestionIndex < _exam!.questions.length) {
      return _exam!.questions[_currentQuestionIndex];
    }
    return null;
  }

  int get totalQuestions => _exam?.totalQuestions ?? 0;
  int get answeredQuestions => _answers.length;
  int get remainingQuestions => totalQuestions - answeredQuestions;

  /// Load exam data
  Future<void> loadExam(String examId) async {
    _state = ExamState.loading;
    notifyListeners();

    final result = await _getExamUseCase.call(examId);

    result.fold(
      (failure) {
        _state = ExamState.error;
        _error = failure.message;
      },
      (exam) async {
        _exam = exam;
        
        // Try to load saved progress
        final savedProgress = await _getProgressUseCase.call(examId);
        if (savedProgress != null) {
          _answers.addAll(savedProgress);
        }
        
        _state = ExamState.loaded;
        _error = null;
      },
    );
    notifyListeners();
  }

  /// Select an answer for the current question
  Future<void> selectAnswer(String optionId) async {
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
    if (_exam == null) return;

    _state = ExamState.loading;
    notifyListeners();

    final result = await _submitExamUseCase.call(_exam!.id, _answers);

    result.fold(
      (failure) {
        _state = ExamState.error;
        _error = failure.message;
      },
      (examResult) {
        _result = examResult;
        _isSubmitted = true;
        _state = ExamState.loaded;
        _error = null;
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
  String? getUserAnswerForCurrentQuestion() {
    if (currentQuestion == null) return null;
    return _answers[currentQuestion!.id];
  }
}