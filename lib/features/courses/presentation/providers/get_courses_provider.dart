import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/enroll_usecase.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_course_progress.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_mycourese_usecase.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/courses/domain/usecases/get_courses_usecase.dart';

class GetCoursesProvider extends ChangeNotifier {
  final GetCoursesUsecase coursesUsecase;
  final GetMycoureseUsecase myCoursesUsecase;
  final EnrollUsecase enrollmentUseCase;
  final GetCourseProgressUsecase courseProgressUsecase;

  GetCoursesProvider({
    required this.coursesUsecase,
    required this.myCoursesUsecase,
    required this.enrollmentUseCase,
    required this.courseProgressUsecase,
  });

  bool _isLoading = false;
  bool _isSuccessEnroll = false;
  String? _errorMessage;

  List<CourseEntity> allCourses = [];
  List<CourseEntity> myCourses = [];
  CourseProgressEntity courseProgress = CourseProgressEntity(
    courseId: 0,
    totalLessons: 0,
    completedLessons: 0,
    progressPercentage: 0,
  );

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
    _isSuccessEnroll = false;
    _errorMessage = null;
    notifyListeners();

    final result = await enrollmentUseCase(
      EnrollUsecaseParams(courseId: courseId),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isSuccessEnroll = false;
        _isLoading = false;
        notifyListeners();
      },
      (isSuccess) {
        // 🌟 استدعاء النقل المحلي فور نجاح الرد من السيرفر
        _moveCourseToMyCourses(courseId);

        _isSuccessEnroll = true;
        _isLoading = false;
        _errorMessage = null;

        // notifyListeners هنا ستجعل القوائم في الواجهة تتحدث فوراً
        notifyListeners();
      },
    );
  }

  Future<void> _getCourseProgress({required int courseId}) async {
    try {
      if (courseId == null) return;

      _isLoading = true;
      final data = await courseProgressUsecase(
        GetCourseProgressParams(courseId: courseId),
      );
      data.fold(
        (failure) {
          _errorMessage = failure.message;
          notifyListeners();
          debugPrint("Error fetching course progress: ${failure.message}");
        },
        (progress) {
          courseProgress = progress;
          notifyListeners();
          debugPrint("Course progress for course $courseId: $progress");
        },
      );
    } catch (e) {}
  }

  void _moveCourseToMyCourses(int courseId) {
    try {
      // البحث عن الكورس في القائمة العامة
      final courseIndex = allCourses.indexWhere((c) => c.id == courseId);

      if (courseIndex != -1) {
        final CourseEntity originalCourse = allCourses[courseIndex];

        final updatedCourse = originalCourse.copyWith(isEnrolled: true);
        originalCourse.copyWith(id: 55);

        allCourses.removeAt(courseIndex);
        if (!myCourses.any((c) => c.id == courseId)) {
          myCourses.add(updatedCourse);
        }

        notifyListeners();
        debugPrint("تم نقل الكورس بنجاح كـ Entity");
      }
    } catch (e) {
      // هذا هو الخطأ الذي ظهر لك، والآن سيعطيك تفاصيل أكثر إذا استمر
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
