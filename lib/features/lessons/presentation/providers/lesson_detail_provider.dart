import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:flutter/foundation.dart';

class LessonDetailState {
  final bool isLoading;
  final String? errorMessage;
  final LessonDetail? lesson;

  const LessonDetailState({
    required this.isLoading,
    required this.errorMessage,
    required this.lesson,
  });

  factory LessonDetailState.initial() {
    return const LessonDetailState(
      isLoading: false,
      errorMessage: null,
      lesson: null,
    );
  }

  LessonDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    LessonDetail? lesson,
  }) {
    return LessonDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lesson: lesson ?? this.lesson,
    );
  }
}

class LessonDetailProvider extends ChangeNotifier {
  final GetLessonDetail _getLessonDetail;
  LessonDetailState _state = LessonDetailState.initial();

  LessonDetailProvider(this._getLessonDetail);

  LessonDetailState get state => _state;
  Future<void> loadLesson(int lessonId) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await _getLessonDetail(lessonId);

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.toString(),
          lesson: null,
        );
        notifyListeners();
      },
      (lesson) {
        _state = _state.copyWith(
          isLoading: false,
          lesson: lesson,
          errorMessage: null,
        );
        notifyListeners();
      },
    );
  }
}
