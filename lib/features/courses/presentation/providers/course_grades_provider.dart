import 'package:algonaid_mobail_app/features/courses/domain/entities/course_grades.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_course_grades.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/utils/notification_service.dart';
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

    await result.fold(
      (failure) async {
        _states[courseId] = _states[courseId]!.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (grades) async {
        _states[courseId] = _states[courseId]!.copyWith(
          isLoading: false,
          grades: grades,
          errorMessage: null,
        );

        // Check for course gold excellence badge
        final isCourseUnlocked = grades.averagePercentage > 90;
        if (isCourseUnlocked) {
          final cacheKey = 'unlocked_course_gold_$courseId';
          final alreadyNotified = CacheHelper.getBool(key: cacheKey) ?? false;
          if (!alreadyNotified) {
            await CacheHelper.saveData(key: cacheKey, value: true);
            await NotificationService().showNotification(
              title: 'لقد حصلت على وسام التفوق الذهبي! 🏆',
              body: 'تهانينا! لقد اجتزت جميع تحديات الكورس بنجاح بمعدل ${grades.averagePercentage.toStringAsFixed(1)}%.',
            );
          }
        }
      },
    );

    notifyListeners();
  }
}
