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

    final result = await coursesUsecase();

    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (fetchedCourses) {
        _isLoading = false;
        // 🌟 تصفية: نعرض فقط الكورسات التي لم يشترك فيها الطالب في قسم "اكتشف"
        allCourses = fetchedCourses;
                print(allCourses);

        notifyListeners();
      },
    );
  }

  // جلب الكورسات التي سجل بها المستخدم (تابع التعلم)
  Future<void> getMyCourses() async {
    // نلاحظ هنا: لا نجعل الـ Loading يغطي الشاشة كاملة لضمان تجربة أسلس
    _errorMessage = null;

    final result = await myCoursesUsecase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (fetchedCourses) {
        myCourses = fetchedCourses;
        print(myCourses);
        notifyListeners();
      },
    );
  }

  // 🌟 دالة ذكية لتحديث الصفحة بالكامل (Refresh)
  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();
    
    // جلب الدالتين في نفس الوقت لسرعة الأداء
    await Future.wait([
      getCourses(),
      getMyCourses(),
    ]);
    
    _isLoading = false;
    notifyListeners();
  }
}