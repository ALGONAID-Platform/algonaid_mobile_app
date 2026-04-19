import 'package:algonaid_mobail_app/features/courses/domain/usecases/enroll_usecase.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_mycourese_usecase.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_courses_usecase.dart';

class GetCoursesProvider extends ChangeNotifier {
  final GetCoursesUsecase coursesUsecase;
  final GetMycoureseUsecase myCoursesUsecase;
  final EnrollUsecase enrollmentUseCase;

  GetCoursesProvider({
    required this.coursesUsecase,
    required this.myCoursesUsecase,
    required this.enrollmentUseCase,
  });

  bool _isLoading = false;
  bool _isSuccessEnroll = false;
  String? _errorMessage;

  List<CourseEntity> allCourses = [];
  List<CourseEntity> myCourses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccessEnroll => _isSuccessEnroll;

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

Future<void> enrollInCourse({int? courseId}) async {
  if (courseId == null) return;

  _isLoading = true;
  _isSuccessEnroll = false; // 🌟 إعادة ضبط الحالة عند بدء طلب جديد
  _errorMessage = null;
  notifyListeners();

  final result = await enrollmentUseCase(
    EnrollUsecaseParams(courseId: courseId),
  );

  result.fold(
    (failure) {
      _errorMessage = failure.message;
      _isSuccessEnroll = false; // فشل التسجيل
      _isLoading = false;
      notifyListeners();
    },
    (isSuccess) {
      _moveCourseToMyCourses(courseId);
      _isSuccessEnroll = true; // 🌟 نجاح التسجيل
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    },
  );
}

void _moveCourseToMyCourses(int courseId) {
  try {
    final courseIndex = allCourses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      final updatedCourse = allCourses[courseIndex].copyWith(isEnrolled: true);
      allCourses.removeAt(courseIndex);
      myCourses.add(updatedCourse);
      // لا تضع notifyListeners هنا لأن الدالة الأب ستستدعيها
    }
  } catch (e) {
    debugPrint("Error updating local lists: $e");
  }
}

  Future<void> refreshAll() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([getCourses(), getMyCourses()]);

    _isLoading = false;
    notifyListeners();
  }
}
