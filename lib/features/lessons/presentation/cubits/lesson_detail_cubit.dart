import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class LessonDetailCubit extends Cubit<LessonDetailState> {
  final GetLessonDetail _getLessonDetail;

  LessonDetailCubit(this._getLessonDetail)
      : super(LessonDetailState.initial());

  Future<void> loadLesson(int lessonId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final lesson = await _getLessonDetail(lessonId);
      emit(state.copyWith(isLoading: false, lesson: lesson));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          lesson: null,
        ),
      );
    }
  }
}
