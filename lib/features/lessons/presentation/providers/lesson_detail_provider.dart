import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:flutter/foundation.dart';

class LessonDetailState {
  final bool isLoading;
  final String? errorMessage;
  final LessonDetail? lesson;
  final Exam? exam; // New field for associated exam

  const LessonDetailState({
    required this.isLoading,
    required this.errorMessage,
    required this.lesson,
    this.exam, // Make exam optional in constructor
  });

  factory LessonDetailState.initial() {
    return const LessonDetailState(
      isLoading: false,
      errorMessage: null,
      lesson: null,
      exam: null, // Initialize exam as null
    );
  }

  LessonDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    LessonDetail? lesson,
    Exam? exam, // Allow exam to be copied
  }) {
    return LessonDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lesson: lesson ?? this.lesson,
      exam: exam ?? this.exam, // Copy exam
    );
  }
}

class LessonDetailProvider extends ChangeNotifier {
  final GetLessonDetail _getLessonDetail;
  LessonDetailState _state = LessonDetailState.initial();

  LessonDetailProvider(this._getLessonDetail);

  LessonDetailState get state => _state;
  Future<void> loadLesson(int lessonId) async {
    debugPrint(
      'LessonDetailProvider: loadLesson started for lessonId=$lessonId',
    );
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _getLessonDetail(lessonId);

    result.fold(
      (failure) {
        debugPrint(
          'LessonDetailProvider: loadLesson failed for lessonId=$lessonId, error=${failure.message}',
        );
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          lesson: null,
          exam: null, // Clear exam on failure
        );
        notifyListeners();
      },
      (lesson) {
        debugPrint(
          'LessonDetailProvider: loadLesson succeeded for lessonId=$lessonId, '
          'lessonId=${lesson.id}, examId=${lesson.exam?.id}, title=${lesson.title}',
        );
        _state = _state.copyWith(
          isLoading: false,
          lesson: lesson,
          errorMessage: null,
          exam: lesson.exam,
        );
        notifyListeners();
      },
    );
  }
}
