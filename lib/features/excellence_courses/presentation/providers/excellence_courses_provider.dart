import 'package:algonaid_mobail_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/usecases/get_excellence_courses_usecase.dart';
import 'package:flutter/material.dart';

class ExcellenceCoursesProvider extends ChangeNotifier {
  final GetExcellenceCoursesUseCase getExcellenceCoursesUseCase;

  ExcellenceCoursesProvider({
    required this.getExcellenceCoursesUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  List<ExcellenceCourseEntity> _courses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ExcellenceCourseEntity> get courses => _courses;

  Future<void> fetchExcellenceCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getExcellenceCoursesUseCase();

    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (coursesList) {
        _isLoading = false;
        _courses = coursesList;
        notifyListeners();
      },
    );
  }
}
