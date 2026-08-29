import 'package:flutter/material.dart';
import 'package:algonaid/core/di/service_locator.dart';
import 'package:algonaid/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid/features/exams/domain/usecases/exam_usecases.dart';
import 'package:algonaid/core/utils/notification_service.dart';
import 'package:hive/hive.dart';

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

  // New logic for attempts and duration
  int get currentAttempts {
    if (_exam == null) return 0;
    if (!Hive.isBoxOpen('user_exam_attempts')) return 0;
    final box = Hive.box<String>('user_exam_attempts');
    final countStr = box.get(_exam!.id.toString());
    return countStr != null ? (int.tryParse(countStr) ?? 0) : 0;
  }

  int get remainingAttempts {
    final remaining = 3 - currentAttempts;
    return remaining < 0 ? 0 : remaining;
  }
  
  bool get hasExceededAttempts => currentAttempts >= 3;

  int get examDurationMinutes {
    final qCount = totalQuestions;
    if (qCount == 0) return 15;
    if (qCount == 1) return 15;
    if (qCount == 2 || qCount == 3) return 20;
    if (qCount >= 4 && qCount <= 6) return 30;
    return 40;
  }

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
      if (_isSubmitted) {
        resetExam();
      } else {
        debugPrint(
          'ExamProvider: loadExam skipped because examId=$examId is already loaded',
        );
        return;
      }
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
    
    // Ensure the Hive boxes are open so we can read the correct attempt count and cached answers
    try {
      if (!Hive.isBoxOpen('user_exam_attempts')) {
        await Hive.openBox<String>('user_exam_attempts');
      }
      if (!Hive.isBoxOpen('exam_correct_answers')) {
        await Hive.openBox<Map>('exam_correct_answers');
      }
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
    }

    if (hasListeners) {
      notifyListeners();
    }

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
        if (hasListeners) {
      notifyListeners();
    }
        return;
      }

      if (_questions.isEmpty) {
        debugPrint(
          'ExamProvider: examId=$examId has no questions after getExam/startExam',
        );
        _state = ExamState.error;
        _error = 'هذا الاختبار لا يحتوي على أسئلة حالياً.';
        if (hasListeners) {
      notifyListeners();
    }
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
        if (hasListeners) {
      notifyListeners();
    }
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
    if (hasListeners) {
      notifyListeners();
    }
  }

  /// Select an answer for the current question
  Future<void> selectAnswer(int optionId) async {
    if (currentQuestion != null) {
      _answers[currentQuestion!.id] = optionId;

      // Auto-save progress
      if (_exam != null) {
        await _saveProgressUseCase.call(_exam!.id, _answers);
      }

      if (hasListeners) {
      notifyListeners();
    }
    }
  }

  /// Move to next question
  void nextQuestion() {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      if (hasListeners) {
      notifyListeners();
    }
    }
  }

  /// Move to previous question
  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      if (hasListeners) {
      notifyListeners();
    }
    }
  }

  /// Jump to specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentQuestionIndex = index;
      if (hasListeners) {
      notifyListeners();
    }
    }
  }

  /// Submit exam
  Future<void> submitExam() async {
    if (_exam == null || _attemptId == null) return;

    _state = ExamState.loading;
    if (hasListeners) {
      notifyListeners();
    }

    if (_attemptId! <= 0) {
      // Evaluate locally
      int correctCount = 0;
      int wrongCount = 0;
      Map<int, int> correctOptionsMap = {};

      // Try to load cached correct answers
      try {
        if (Hive.isBoxOpen('exam_correct_answers')) {
          final box = Hive.box<Map>('exam_correct_answers');
          final cached = box.get(_exam!.id.toString());
          if (cached != null) {
             correctOptionsMap = cached.map((k, v) => MapEntry(int.parse(k.toString()), v as int));
          }
        }
      } catch (e) {
        debugPrint('Error loading cached correct answers: $e');
      }

      for (var question in _questions) {
        final userAns = _answers[question.id];
        bool isCorrectAns = false;
        
        // 1. If we have the cached correct answer, use it
        if (correctOptionsMap.containsKey(question.id)) {
          if (userAns == correctOptionsMap[question.id]) {
            isCorrectAns = true;
          }
        } else {
          // 2. Fallback to checking option.isCorrect if the cache doesn't have it
          for (var option in question.options) {
            if (option.isCorrect) {
              correctOptionsMap[question.id] = option.id;
              if (userAns == option.id) {
                isCorrectAns = true;
              }
            }
          }
        }
        
        if (isCorrectAns) {
          correctCount++;
        } else {
          wrongCount++;
        }
      }

      int finalScore = 0;
      if (totalQuestions > 0) {
        finalScore = ((correctCount / totalQuestions) * 100).toInt();
      }

      _result = ExamResult(
        attemptId: _attemptId!,
        examId: _exam!.id,
        studentId: 0,
        score: finalScore,
        status: 'COMPLETED_LOCALLY',
        submittedAt: DateTime.now(),
        totalQuestions: totalQuestions,
        correctAnswers: correctCount,
        wrongAnswers: wrongCount,
        answers: _answers,
        correctOptions: correctOptionsMap,
      );
      _isSubmitted = true;
      _state = ExamState.loaded;
      _error = null;
      await _saveProgressUseCase.call(_exam!.id, <int, int>{});
      
      // Increment local attempt count even for bypassed/local submissions
      try {
        if (!Hive.isBoxOpen('user_exam_attempts')) {
          await Hive.openBox<String>('user_exam_attempts');
        }
        final box = Hive.box<String>('user_exam_attempts');
        final newAttempts = currentAttempts >= 3 ? 3 : currentAttempts + 1;
        await box.put(_exam!.id.toString(), newAttempts.toString());
      } catch (e) {
        debugPrint('Error saving local attempt count: $e');
      }

      if (hasListeners) {
        notifyListeners();
      }
      return;
    }

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
          fetchedResult.fold((_) {}, (latestResult) async {
            _result = latestResult;
            
            // Save correct answers to Hive for future local evaluations
            try {
              if (!Hive.isBoxOpen('exam_correct_answers')) {
                await Hive.openBox<Map>('exam_correct_answers');
              }
              final correctAnswersBox = Hive.box<Map>('exam_correct_answers');
              // Store as Map<dynamic, dynamic> which Hive supports for simple types
              final storableMap = latestResult.correctOptions.map((k, v) => MapEntry(k.toString(), v));
              await correctAnswersBox.put(_exam!.id.toString(), storableMap);
            } catch (e) {
              debugPrint('Error saving correct answers: $e');
            }
          });
        } catch (_) {}
        await _saveProgressUseCase.call(_exam!.id, <int, int>{});

        // Trigger local notification (which plays sound and saves to history)
        try {
          final percent = (examResult.correctAnswers / examResult.totalQuestions * 100).toStringAsFixed(0);
          await NotificationService().showNotification(
            title: 'تم إكمال الاختبار بنجاح! 📝',
            body: 'لقد أكملت اختبار "${_exam?.title}" بنجاح وحصلت على درجة $percent% (${examResult.correctAnswers}/${examResult.totalQuestions}).',
          );
        } catch (e) {
          debugPrint('Error triggering exam completion notification: $e');
        }
        
        // Increment local attempt count
        try {
          if (!Hive.isBoxOpen('user_exam_attempts')) {
            await Hive.openBox<String>('user_exam_attempts');
          }
          final box = Hive.box<String>('user_exam_attempts');
          final newAttempts = currentAttempts + 1;
          await box.put(_exam!.id.toString(), newAttempts.toString());
        } catch (e) {
          debugPrint('Error saving local attempt count: $e');
        }
      },
    );
    if (hasListeners) {
      notifyListeners();
    }
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
    if (hasListeners) {
      notifyListeners();
    }
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
