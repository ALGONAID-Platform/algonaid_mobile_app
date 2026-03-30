import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:flutter/foundation.dart';

class LessonsListState {
  final bool isLoading;
  final String? errorMessage;
  final List<Lesson> lessons;

  const LessonsListState({
    required this.isLoading,
    required this.errorMessage,
    required this.lessons,
  });

  factory LessonsListState.initial() {
    return const LessonsListState(
      isLoading: false,
      errorMessage: null,
      lessons: [],
    );
  }

  LessonsListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Lesson>? lessons,
  }) {
    return LessonsListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lessons: lessons ?? this.lessons,
    );
  }
}

class LessonsListProvider extends ChangeNotifier {
  final GetModuleLessons _getModuleLessons;
  LessonsListState _state = LessonsListState.initial();

  LessonsListProvider(this._getModuleLessons);

  LessonsListState get state => _state;

  Future<void> loadLessons(int moduleId) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final lessons = await _getModuleLessons(moduleId);
      _state = _state.copyWith(
        isLoading: false,
        lessons: lessons,
        errorMessage: null,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        lessons: const [],
      );
      notifyListeners();
    }
  }
}
