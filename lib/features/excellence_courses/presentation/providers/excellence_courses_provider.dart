import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_course_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/usecases/get_cached_excellence_courses_usecase.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/usecases/get_excellence_courses_usecase.dart';
import 'package:algonaid_mobile_app/features/excellence_courses/domain/usecases/get_excellence_modules_usecase.dart';
import 'package:flutter/material.dart';

class ExcellenceCoursesProvider extends ChangeNotifier {
  final GetExcellenceCoursesUseCase getExcellenceCoursesUseCase;
  final GetExcellenceModulesUseCase getExcellenceModulesUseCase;
  final GetCachedExcellenceCoursesUseCase getCachedExcellenceCoursesUseCase;

  ExcellenceCoursesProvider({
    required this.getExcellenceCoursesUseCase,
    required this.getExcellenceModulesUseCase,
    required this.getCachedExcellenceCoursesUseCase,
  });

  // isLoading = true فقط عندما لا يوجد كاش إطلاقاً
  bool _isLoading = false;
  // isBackgroundUpdating = true عند تحديث البيانات في الخلفية مع وجود كاش
  bool _isBackgroundUpdating = false;
  String? _errorMessage;
  List<ExcellenceCourseEntity> _courses = [];

  bool _isModulesLoading = false;
  List<ExcellenceModuleEntity> _currentModules = [];

  bool get isLoading => _isLoading;
  bool get isBackgroundUpdating => _isBackgroundUpdating;
  String? get errorMessage => _errorMessage;
  List<ExcellenceCourseEntity> get courses => _courses;
  bool get isModulesLoading => _isModulesLoading;
  List<ExcellenceModuleEntity> get currentModules => _currentModules;

  Future<void> fetchExcellenceCourses() async {
    // 1. اقرأ الكاش أولاً فوراً بدون أي انتظار
    final cachedResult = getCachedExcellenceCoursesUseCase();
    cachedResult.fold(
      (failure) => debugPrint('Cache miss for excellence courses: ${failure.message}'),
      (cached) {
        if (cached.isNotEmpty) {
          _courses = cached;
          notifyListeners();
        }
      },
    );

    final hasCache = _courses.isNotEmpty;

    // 2. إذا لم يكن هناك كاش → أظهر مؤشر التحميل الكامل
    if (!hasCache) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      // إذا كان هناك كاش → جلب في الخلفية بهدوء
      _isBackgroundUpdating = true;
      notifyListeners();
    }

    // 3. اجلب من السيرفر
    final result = await getExcellenceCoursesUseCase();

    result.fold(
      (failure) {
        // إذا فشل الجلب وكان هناك كاش، لا نُظهر خطأ — نكتفي بالكاش
        _errorMessage = hasCache ? null : failure.message;
        debugPrint('Error loading excellence courses: ${failure.message}');
      },
      (coursesList) {
        _courses = coursesList;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    _isBackgroundUpdating = false;
    notifyListeners();
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
