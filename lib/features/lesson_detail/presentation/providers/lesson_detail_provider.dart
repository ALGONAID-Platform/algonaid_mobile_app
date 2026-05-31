import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/domain/usecases/update_lesson_progress.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:flutter/foundation.dart';

class LessonDetailState {
  final bool isLoading;
  final String? errorMessage;
  final LessonDetail? lesson;
  final Exam? exam;
  final int? nextLessonId;
  final int? previousLessonId;

  const LessonDetailState({
    required this.isLoading,
    required this.errorMessage,
    required this.lesson,
    this.exam,
    this.nextLessonId,
    this.previousLessonId,
  });

  factory LessonDetailState.initial() {
    return const LessonDetailState(
      isLoading: false,
      errorMessage: null,
      lesson: null,
      exam: null,
      nextLessonId: null,
      previousLessonId: null,
    );
  }

  LessonDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    LessonDetail? lesson,
    Exam? exam,
    int? nextLessonId,
    int? previousLessonId,
    bool clearNextLesson = false,
    bool clearPreviousLesson = false,
  }) {
    return LessonDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lesson: lesson ?? this.lesson,
      exam: exam ?? this.exam,
      nextLessonId: clearNextLesson ? null : (nextLessonId ?? this.nextLessonId),
      previousLessonId: clearPreviousLesson ? null : (previousLessonId ?? this.previousLessonId),
    );
  }
}

class LessonDetailProvider extends ChangeNotifier {
  final GetLessonDetail _getLessonDetail;
  final UpdateLessonProgress _updateLessonProgress;
  final GetModuleLessons _getModuleLessons;
  LessonDetailState _state = LessonDetailState.initial();

  LessonDetailProvider(this._getLessonDetail, this._updateLessonProgress, this._getModuleLessons);

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
          exam: null,
          clearNextLesson: true,
          clearPreviousLesson: true,
        );
        notifyListeners();
      },
      (lesson) async {
        debugPrint(
          'LessonDetailProvider: loadLesson succeeded for lessonId=$lessonId, '
          'lessonId=${lesson.id}, examId=${lesson.exam?.id}, title=${lesson.title}',
        );
        _state = _state.copyWith(
          isLoading: false,
          lesson: lesson,
          errorMessage: null,
          exam: lesson.exam,
          clearNextLesson: true,
          clearPreviousLesson: true,
        );
        notifyListeners();

        // Fetch lessons to find next lesson and determine completion status
        final lessonsResult = await _getModuleLessons(lesson.moduleId);
        lessonsResult.fold(
          (_) {
            final isAlreadyCompleted = CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ?? false;
            updateProgress(lesson.id, isAlreadyCompleted);
          }, 
          (lessons) {
            final currentIndex = lessons.indexWhere((l) => l.id == lesson.id);
            bool isCompleted = false;
            if (currentIndex != -1) {
              isCompleted = lessons[currentIndex].status == LessonStatus.completed;
              if (isCompleted) {
                CacheHelper.saveData(key: 'lesson_completed_${lesson.id}', value: true);
              }
              
              int? nextId;
              int? previousId;
              if (currentIndex < lessons.length - 1) {
                nextId = lessons[currentIndex + 1].id;
              }
              if (currentIndex > 0) {
                previousId = lessons[currentIndex - 1].id;
              }
              _state = _state.copyWith(
                nextLessonId: nextId,
                previousLessonId: previousId,
              );
              notifyListeners();
            } else {
              isCompleted = CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ?? false;
            }
            updateProgress(lesson.id, isCompleted);
          }
        );
      },
    );
  }

  Future<void> updateProgress(int lessonId, bool isCompleted) async {
    final result = await _updateLessonProgress(
      lessonId: lessonId,
      isCompleted: isCompleted,
    );

    result.fold(
      (failure) {
        // Optional: handle failure silently or log it
      },
      (_) {
        // Progress successfully updated
      },
    );
  }
}
