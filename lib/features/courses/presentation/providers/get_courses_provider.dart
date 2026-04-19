import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_mycourese_usecase.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_courses_usecase.dart';

class GetCoursesProvider extends ChangeNotifier {
  final GetCoursesUsecase coursesUsecase;
  final GetMycoureseUsecase myCoursesUsecase;

  GetCoursesProvider({
    required this.coursesUsecase,
    required this.myCoursesUsecase,
  });

  bool _isLoading = false;
  String? _errorMessage;

  List<CourseEntity> allCourses = [];
  List<CourseEntity> myCourses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // جلب الكورسات العامة (الاكتشاف)
  Future<void> getCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    debugPrint('getCourses: isLoading set to true');

    final result = await coursesUsecase();

    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
        debugPrint('getCourses: Failed with error: $_errorMessage');
        debugPrint('getCourses: isLoading set to false');
      },
      (fetchedCourses) {
        _isLoading = false;
        allCourses = fetchedCourses;
        debugPrint('getCourses: allCourses loaded. Count: ${allCourses.length}');
        debugPrint('getCourses: isLoading set to false');
        notifyListeners();
      },
    );
  }

  // جلب الكورسات التي سجل بها المستخدم (تابع التعلم)
  Future<void> getMyCourses() async {
    // نلاحظ هنا: لا نجعل الـ Loading يغطي الشاشة كاملة لضمان تجربة أسلس
    _errorMessage = null;
    debugPrint('getMyCourses: started');

    final result = await myCoursesUsecase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        debugPrint('getMyCourses: Failed with error: $_errorMessage');
      },
      (fetchedCourses) {
        myCourses = fetchedCourses;
        debugPrint('getMyCourses: myCourses loaded. Count: ${myCourses.length}');
        notifyListeners();
      },
    );
  }

  // 🌟 دالة ذكية لتحديث الصفحة بالكامل (Refresh)
  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();
    debugPrint('refreshAll: isLoading set to true');

    // جلب الدالتين في نفس الوقت لسرعة الأداء
    await Future.wait([getCourses(), getMyCourses()]);

    _isLoading = false;
    notifyListeners();
    debugPrint('refreshAll: isLoading set to false');
  }
}
