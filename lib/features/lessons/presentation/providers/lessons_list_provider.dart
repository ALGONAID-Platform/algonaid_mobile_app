import 'package:algonaid/core/common/enums/lesson_status.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid/features/lessons/domain/usecases/get_cached_lessons_usecase.dart';
import 'package:flutter/foundation.dart';

class LessonsListState {
  final bool isLoading;
  final bool isBackgroundUpdating;
  final bool isFetchingNextPage;
  final String? errorMessage;
  final List<Lesson> lessons;
  final int currentPage;
  final int totalPages;

  const LessonsListState({
    required this.isLoading,
    required this.isBackgroundUpdating,
    required this.isFetchingNextPage,
    required this.errorMessage,
    required this.lessons,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  /// Whether there are more pages to load
  bool get hasMorePages => currentPage < totalPages;

  factory LessonsListState.initial() {
    return const LessonsListState(
      isLoading: false,
      isBackgroundUpdating: false,
      isFetchingNextPage: false,
      errorMessage: null,
      lessons: [],
      currentPage: 1,
      totalPages: 1,
    );
  }

  LessonsListState copyWith({
    bool? isLoading,
    bool? isBackgroundUpdating,
    bool? isFetchingNextPage,
    String? errorMessage,
    List<Lesson>? lessons,
    int? currentPage,
    int? totalPages,
  }) {
    return LessonsListState(
      isLoading: isLoading ?? this.isLoading,
      isBackgroundUpdating: isBackgroundUpdating ?? this.isBackgroundUpdating,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
      errorMessage: errorMessage,
      lessons: lessons ?? this.lessons,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class LessonsListProvider extends ChangeNotifier {
  final GetModuleLessons _getModuleLessons;
  final GetCachedLessonsUsecase _getCachedLessons;
  LessonsListState _state = LessonsListState.initial();

  LessonsListProvider(this._getModuleLessons, this._getCachedLessons);

  LessonsListState get state => _state;

  Future<void> loadLessons(int moduleId, {bool loadMore = false}) async {
    int pageToLoad = 1;
    if (loadMore) {
      if (_state.isFetchingNextPage) return;

      // لا نطلب صفحات إضافية إذا كنا في الصفحة الأخيرة أو تجاوزناها
      if (!_state.hasMorePages) return;

      pageToLoad = _state.currentPage + 1;

      _state = _state.copyWith(isFetchingNextPage: true, errorMessage: null);
      notifyListeners();
    } else {
      // Reset pagination state for fresh load
      _state = _state.copyWith(
        currentPage: 1,
        totalPages: 1,
      );

      // 1. Read from cache first if we are on first page
      final cachedResult = _getCachedLessons(moduleId);
      cachedResult.fold(
        (failure) {
          _state = _state.copyWith(isLoading: true, isBackgroundUpdating: false, errorMessage: null, lessons: const []);
          notifyListeners();
        }, 
        (cachedLessons) {
          if (cachedLessons.isNotEmpty) {
            _state = _state.copyWith(lessons: cachedLessons, isLoading: false, isBackgroundUpdating: true, errorMessage: null);
          } else {
            _state = _state.copyWith(isLoading: true, isBackgroundUpdating: false, errorMessage: null, lessons: const []);
          }
          notifyListeners();
        },
      );
    }

    // 2. Fetch from remote in background
    final result = await _getModuleLessons(GetModuleLessonsParams(moduleId: moduleId, page: pageToLoad));
    
    if (!hasListeners) return;

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          isBackgroundUpdating: false,
          isFetchingNextPage: false,
          errorMessage: _state.lessons.isEmpty ? failure.message : null,
          lessons: _state.lessons.isEmpty ? const [] : _state.lessons,
        );
      },
      (paginatedLessons) {
        for (var lesson in paginatedLessons.lessons) {
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
        
        final newLessons = loadMore
            ? () {
                // دمج الدروس الجديدة مع الموجودة مع إزالة التكرار بناءً على الـ ID
                final existingIds = _state.lessons.map((l) => l.id).toSet();
                final uniqueNew = paginatedLessons.lessons
                    .where((l) => !existingIds.contains(l.id))
                    .toList();
                return [..._state.lessons, ...uniqueNew];
              }()
            : paginatedLessons.lessons;
            
        _state = _state.copyWith(
          isLoading: false,
          isBackgroundUpdating: false,
          isFetchingNextPage: false,
          lessons: newLessons,
          currentPage: paginatedLessons.lessons.isEmpty && loadMore 
              ? _state.currentPage // Keep current page if nothing was returned
              : paginatedLessons.meta.page,
          totalPages: paginatedLessons.meta.totalPages,
          errorMessage: null,
        );
      },
    );
    notifyListeners();
  }

  void markLessonCompletedLocally(int lessonId) {
    final updatedLessons = _state.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(status: LessonStatus.completed);
      }
      return lesson;
    }).toList();
    _state = _state.copyWith(lessons: updatedLessons);
    notifyListeners();
  }
}
