import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';

class LessonsListState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final List<Lesson> lessons;

  const LessonsListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.errorMessage,
    required this.lessons,
  });

  factory LessonsListState.initial() {
    return const LessonsListState(
      isLoading: false,
      isLoadingMore: false,
      hasMore: false,
      errorMessage: null,
      lessons: [],
    );
  }

  LessonsListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    List<Lesson>? lessons,
  }) {
    return LessonsListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
      lessons: lessons ?? this.lessons,
    );
  }
}

class LessonsListProvider extends ChangeNotifier {
  final GetModuleLessons _getModuleLessons;
  LessonsListState _state = LessonsListState.initial();
  final List<Lesson> _allLessons = [];
  int _pageIndex = 0;

  LessonsListProvider(this._getModuleLessons);

  LessonsListState get state => _state;

  Future<void> loadLessons(int moduleId) async {
    _state = _state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      hasMore: false,
      errorMessage: null,
      lessons: const [],
    );
    _allLessons.clear();
    _pageIndex = 0;
    notifyListeners();

    final result = await _getModuleLessons(moduleId);
    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          hasMore: false,
          errorMessage: failure.message,
          lessons: const [],
        );
        notifyListeners();
      },
      (lessons) {
        _allLessons
          ..clear()
          ..addAll(lessons);
        final firstPage = _getPage(_pageIndex);
        final hasMore = _allLessons.length > firstPage.length;
        _state = _state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          hasMore: hasMore,
          lessons: firstPage,
          errorMessage: null,
        );
        notifyListeners();
      },
    );
  }

  void loadMore() {
    if (_state.isLoading || _state.isLoadingMore || !_state.hasMore) {
      return;
    }

    _state = _state.copyWith(isLoadingMore: true);
    notifyListeners();

    final nextPageIndex = _pageIndex + 1;
    final nextItems = _getPage(nextPageIndex);

    if (nextItems.isEmpty) {
      _state = _state.copyWith(isLoadingMore: false, hasMore: false);
      notifyListeners();
      return;
    }

    _pageIndex = nextPageIndex;
    final updatedLessons = [..._state.lessons, ...nextItems];
    final hasMore = updatedLessons.length < _allLessons.length;
    _state = _state.copyWith(
      isLoadingMore: false,
      hasMore: hasMore,
      lessons: updatedLessons,
    );
    notifyListeners();
  }

  List<Lesson> _getPage(int pageIndex) {
    const limit = AppConstants.itemsPerPage;
    final startIndex = pageIndex * limit;
    if (startIndex >= _allLessons.length) return const [];
    final endIndex = (startIndex + limit) > _allLessons.length
        ? _allLessons.length
        : startIndex + limit;
    return _allLessons.sublist(startIndex, endIndex);
  }
}
