import 'package:algonaid_mobail_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/usecases/get_excellence_courses_usecase.dart';
import 'package:algonaid_mobail_app/features/excellence_courses/domain/usecases/get_excellence_modules_usecase.dart';
import 'package:flutter/material.dart';

class ExcellenceCoursesProvider extends ChangeNotifier {
  final GetExcellenceCoursesUseCase getExcellenceCoursesUseCase;
  final GetExcellenceModulesUseCase getExcellenceModulesUseCase;

  ExcellenceCoursesProvider({
    required this.getExcellenceCoursesUseCase,
    required this.getExcellenceModulesUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  List<ExcellenceCourseEntity> _courses = [];

  bool _isModulesLoading = false;
  List<ExcellenceModuleEntity> _currentModules = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ExcellenceCourseEntity> get courses => _courses;
  bool get isModulesLoading => _isModulesLoading;
  List<ExcellenceModuleEntity> get currentModules => _currentModules;

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

  Future<void> fetchExcellenceModules(int courseId) async {
    _isModulesLoading = true;
    _currentModules = [];
    notifyListeners();

    final result = await getExcellenceModulesUseCase(courseId);

    result.fold(
      (failure) {
        _isModulesLoading = false;
        notifyListeners();
      },
      (modules) {
        _isModulesLoading = false;
        _currentModules = modules;
        notifyListeners();
      },
    );
  }
}
