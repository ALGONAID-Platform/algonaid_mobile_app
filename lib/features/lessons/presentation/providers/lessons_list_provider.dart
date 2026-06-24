import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/usecases/get_cached_lessons_usecase.dart';
import 'package:flutter/foundation.dart';

class LessonsListState {
  final bool isLoading;
  final bool isBackgroundUpdating;
  final String? errorMessage;
  final List<Lesson> lessons;

  const LessonsListState({
    required this.isLoading,
    required this.isBackgroundUpdating,
    required this.errorMessage,
    required this.lessons,
  });

  factory LessonsListState.initial() {
    return const LessonsListState(
      isLoading: false,
      isBackgroundUpdating: false,
      errorMessage: null,
      lessons: [],
    );
  }

  LessonsListState copyWith({
    bool? isLoading,
    bool? isBackgroundUpdating,
    String? errorMessage,
    List<Lesson>? lessons,
  }) {
    return LessonsListState(
      isLoading: isLoading ?? this.isLoading,
      isBackgroundUpdating: isBackgroundUpdating ?? this.isBackgroundUpdating,
      errorMessage: errorMessage,
      lessons: lessons ?? this.lessons,
    );
  }
}

class LessonsListProvider extends ChangeNotifier {
  final GetModuleLessons _getModuleLessons;
  final GetCachedLessonsUsecase _getCachedLessons;
  LessonsListState _state = LessonsListState.initial();

  LessonsListProvider(this._getModuleLessons, this._getCachedLessons);

  LessonsListState get state => _state;

  Future<void> loadLessons(int moduleId) async {
    // 1. Read from cache first
    final cachedResult = _getCachedLessons(moduleId);
    cachedResult.fold(
      (failure) {}, // Ignore cache errors
      (cachedLessons) {
        if (cachedLessons.isNotEmpty) {
          _state = _state.copyWith(lessons: cachedLessons, isLoading: false, isBackgroundUpdating: true, errorMessage: null);
          notifyListeners();
        } else {
          _state = _state.copyWith(isLoading: true, isBackgroundUpdating: false, errorMessage: null);
          notifyListeners();
        }
      },
    );

    // 2. Fetch from remote in background
    final result = await _getModuleLessons(moduleId);
    
    if (!hasListeners) return;

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          isBackgroundUpdating: false,
          errorMessage: _state.lessons.isEmpty ? failure.message : null,
          lessons: _state.lessons.isEmpty ? const [] : _state.lessons,
        );
      },
      (lessons) {
        for (var lesson in lessons) {
          if (lesson.status == LessonStatus.completed) {
            CacheHelper.saveData(
              key: 'lesson_completed_${lesson.id}',
              value: true,
            );
          } else {
            CacheHelper.saveData(
              key: 'lesson_completed_${lesson.id}',
              value: false,
            );
          }
        }
        _state = _state.copyWith(
          isLoading: false,
          isBackgroundUpdating: false,
          lessons: lessons,
          errorMessage: null,
        );
      },
    );
    notifyListeners();
  }
}
