import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/search/domain/entities/global_search_entity.dart';
import 'package:algonaid_mobail_app/features/search/domain/usecases/search_courses_usecase.dart';
import 'dart:async';

class SearchCoursesProvider extends ChangeNotifier {
  final SearchCoursesUseCase searchCoursesUseCase;

  SearchCoursesProvider({required this.searchCoursesUseCase});

  List<CourseEntity> _courses = [];
  List<CourseEntity> get courses => _courses;

  List<SearchModuleEntity> _modules = [];
  List<SearchModuleEntity> get modules => _modules;

  List<SearchLessonEntity> _lessons = [];
  List<SearchLessonEntity> get lessons => _lessons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  Timer? _debounce;

  void searchCourses(String query) {
    _currentQuery = query;

    if (query.isEmpty) {
      _courses = [];
      _modules = [];
      _lessons = [];
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await searchCoursesUseCase.call(query);

      result.fold(
        (failure) {
          _error = failure.message;
          _courses = [];
          _modules = [];
          _lessons = [];
          _isLoading = false;
          notifyListeners();
        },
        (globalSearch) {
          _courses = globalSearch.courses;
          _modules = globalSearch.modules;
          _lessons = globalSearch.lessons;
          _error = null;
          _isLoading = false;
          notifyListeners();
        },
      );
    });
  }

  void clearSearch() {
    _currentQuery = '';
    _courses = [];
    _modules = [];
    _lessons = [];
    _error = null;
    _isLoading = false;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    notifyListeners();
  }
}
