import 'package:algonaid_mobile_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/domain/usecases/update_lesson_progress.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
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
    bool clearLesson = false,
    bool clearExam = false,
    bool clearNextLesson = false,
    bool clearPreviousLesson = false,
  }) {
    return LessonDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lesson: clearLesson ? null : (lesson ?? this.lesson),
      exam: clearExam ? null : (exam ?? this.exam),
      nextLessonId: clearNextLesson
          ? null
          : (nextLessonId ?? this.nextLessonId),
      previousLessonId: clearPreviousLesson
          ? null
          : (previousLessonId ?? this.previousLessonId),
    );
  }
}

class LessonDetailProvider extends ChangeNotifier {
  final GetLessonDetail _getLessonDetail;
  final UpdateLessonProgress _updateLessonProgress;
  final GetModuleLessons _getModuleLessons;
  LessonDetailState _state = LessonDetailState.initial();

  LessonDetailProvider(
    this._getLessonDetail,
    this._updateLessonProgress,
    this._getModuleLessons,
  );

  LessonDetailState get state => _state;

  Future<void> loadLesson(int lessonId) async {
    debugPrint(
      'LessonDetailProvider: loadLesson started for lessonId=$lessonId',
    );
    _state = _state.copyWith(
      isLoading: true, 
      errorMessage: null,
      clearLesson: true,
      clearExam: true,
      clearNextLesson: true,
      clearPreviousLesson: true,
    );
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
        final lessonsResult = await _getModuleLessons(GetModuleLessonsParams(moduleId: lesson.moduleId, page: 1, limit: 100));
        lessonsResult.fold(
          (_) {
            var isAlreadyCompleted =
                CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ??
                false;
            // Removed automatic updateProgress here because the UI now calls it directly as completed.
          },
          (paginatedLessons) {
            final sortedLessons = [...paginatedLessons.lessons]
              ..sort((a, b) {
                final orderCompare = a.order.compareTo(b.order);
                if (orderCompare != 0) return orderCompare;
                return a.id.compareTo(b.id);
              });

            final currentIndex = sortedLessons.indexWhere(
              (l) => l.id == lesson.id,
            );
            bool isCompleted = false;
            if (currentIndex != -1) {
              isCompleted =
                  sortedLessons[currentIndex].status == LessonStatus.completed;
              if (isCompleted) {
                CacheHelper.saveData(
                  key: 'lesson_completed_${lesson.id}',
                  value: true,
                );
              }

              int? nextId;
              int? previousId;
              if (currentIndex < sortedLessons.length - 1) {
                nextId = sortedLessons[currentIndex + 1].id;
              }
              if (currentIndex > 0) {
                previousId = sortedLessons[currentIndex - 1].id;
              }
              _state = _state.copyWith(
                nextLessonId: nextId,
                previousLessonId: previousId,
              );
              notifyListeners();
            } else {
              isCompleted =
                  CacheHelper.getBool(key: 'lesson_completed_${lesson.id}') ??
                  false;
            }
            // Removed automatic updateProgress here because the UI now calls it directly as completed.
          },
        );
      },
    );
  }

  Future<bool> updateProgress(int lessonId, bool isCompleted) async {
    final result = await _updateLessonProgress(
      lessonId: lessonId,
      isCompleted: isCompleted,
    );

    return result.fold(
      (failure) {
        return false;
      },
      (_) {
        return true;
      },
    );
  }
}
