import 'package:algonaid_mobail_app/features/courses/domain/entities/course_grades.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_course_grades.dart';
import 'package:flutter/material.dart';

class CourseGradesState {
  final bool isLoading;
  final String? errorMessage;
  final CourseGrades? grades;

  CourseGradesState({
    this.isLoading = false,
    this.errorMessage,
    this.grades,
  });

  CourseGradesState copyWith({
    bool? isLoading,
    String? errorMessage,
    CourseGrades? grades,
  }) {
    return CourseGradesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      grades: grades ?? this.grades,
    );
  }
}

class CourseGradesProvider extends ChangeNotifier {
  final GetCourseGrades getCourseGrades;
  final Map<int, CourseGradesState> _states = {};

  CourseGradesProvider({required this.getCourseGrades});

  CourseGradesState getState(int courseId) {
    return _states[courseId] ?? CourseGradesState();
  }

  Future<void> fetchGrades(int courseId) async {
    final currentState = getState(courseId);
    if (currentState.isLoading) return;

    _states[courseId] = currentState.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await getCourseGrades(courseId);

    result.fold(
      (failure) {
        _states[courseId] = _states[courseId]!.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (grades) {
        _states[courseId] = _states[courseId]!.copyWith(
          isLoading: false,
          grades: grades,
          errorMessage: null,
        );
      },
    );

    notifyListeners();
  }
}
