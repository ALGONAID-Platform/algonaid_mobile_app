import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_module_lessons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class LessonsListCubit extends Cubit<LessonsListState> {
  final GetModuleLessons _getModuleLessons;

  LessonsListCubit(this._getModuleLessons) : super(LessonsListState.initial());

  Future<void> loadLessons(int moduleId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final lessons = await _getModuleLessons(moduleId);
      emit(state.copyWith(isLoading: false, lessons: lessons));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          lessons: const [],
        ),
      );
    }
  }
}
