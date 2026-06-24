import 'package:algonaid_mobile_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/enroll_usecase.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/get_course_progress.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/get_mycourese_usecase.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/get_cached_courses_usecase.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/get_cached_mycourses_usecase.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobile_app/features/courses/domain/usecases/get_courses_usecase.dart';

class GetCoursesProvider extends ChangeNotifier {
  final GetCoursesUsecase coursesUsecase;
  final GetMycoureseUsecase myCoursesUsecase;
  final GetCachedCoursesUsecase getCachedCoursesUsecase;
  final GetCachedMyCoursesUsecase getCachedMyCoursesUsecase;
  final EnrollUsecase enrollmentUseCase;
  final GetCourseProgressUsecase courseProgressUsecase;

  GetCoursesProvider({
    required this.coursesUsecase,
    required this.myCoursesUsecase,
    required this.getCachedCoursesUsecase,
    required this.getCachedMyCoursesUsecase,
    required this.enrollmentUseCase,
    required this.courseProgressUsecase,
  });

  bool _isLoading = false;
  bool _isBackgroundUpdating = false;
  bool _isEnrolling = false;
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
  bool get isBackgroundUpdating => _isBackgroundUpdating;
  bool get isEnrolling => _isEnrolling;
  String? get errorMessage => _errorMessage;
  bool get isSuccessEnroll => _isSuccessEnroll;

  // تحميل الكاش محلياً بشكل متزامن
  void loadCachedData({bool isGuest = false}) {
    final cachedResult = getCachedCoursesUsecase();
    cachedResult.fold(
      (failure) => debugPrint('Error loading cached courses: ${failure.message}'),
      (courses) {
        allCourses = courses;
      },
    );

    if (!isGuest) {
      final cachedMyResult = getCachedMyCoursesUsecase();
      cachedMyResult.fold(
        (failure) => debugPrint('Error loading cached myCourses: ${failure.message}'),
        (courses) {
          myCourses = courses;
        },
      );
    } else {
      myCourses = [];
    }
    notifyListeners();
  }

  // جلب الكورسات العامة (الاكتشاف)
  Future<void> getCourses({bool showLoading = false}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      debugPrint('getCourses: isLoading set to true');
    }

    final result = await coursesUsecase();

    result.fold(
      (failure) {
        if (showLoading) {
          _isLoading = false;
        }
        _errorMessage = failure.message;
        notifyListeners();
        debugPrint('getCourses: Failed with error: $_errorMessage');
      },
      (fetchedCourses) {
        if (showLoading) {
          _isLoading = false;
        }
        allCourses = fetchedCourses;
        notifyListeners();
      },
    );
  }

  // جلب الكورسات التي سجل بها المستخدم (تابع التعلم)
  Future<void> getMyCourses({bool showLoading = false}) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }
    debugPrint('getMyCourses: started');

    final result = await myCoursesUsecase();

    result.fold(
      (failure) {
        if (showLoading) {
          _isLoading = false;
        }
        _errorMessage = failure.message;
        notifyListeners();
        debugPrint('getMyCourses: Failed with error: $_errorMessage');
      },
      (fetchedCourses) {
        if (showLoading) {
          _isLoading = false;
        }
        myCourses = fetchedCourses;
        debugPrint(
          'getMyCourses: myCourses loaded. Count: ${myCourses.length}',
        );
        notifyListeners();
      },
    );
  }

  Future<void> enrollInCourse({int? courseId}) async {
    if (courseId == null) return;

    _isEnrolling = true;
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
        _isEnrolling = false;
        notifyListeners();
      },
      (isSuccess) {
        // 🌟 استدعاء النقل المحلي فور نجاح الرد من السيرفر
        _moveCourseToMyCourses(courseId);

        _isSuccessEnroll = true;
        _isEnrolling = false;
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

        allCourses.removeAt(courseIndex);
        allCourses = List.from(
          allCourses,
        ); // Create new reference for UI rebuild

        if (!myCourses.any((c) => c.id == courseId)) {
          myCourses = List.from(myCourses)
            ..insert(
              0,
              updatedCourse,
            ); // Insert at the beginning and update reference
        }

        notifyListeners();
        debugPrint("تم نقل الكورس بنجاح كـ Entity");
      }
    } catch (e) {
      // هذا هو الخطأ الذي ظهر لك، والآن سيعطيك تفاصيل أكثر إذا استمر
      debugPrint("Error updating local lists: $e");
    }
  }

  Future<void> refreshAll({bool isGuest = false}) async {
    // 1. قراءة البيانات المخزنة مؤقتاً فوراً لمنع الوميض
    loadCachedData(isGuest: isGuest);

    // 2. إذا كان الكاش فارغاً تماماً، نُظهر الشيمر الرئيسي
    // وإلا، نعتمد على الكاش ونقوم بالتحديث في الخلفية بهدوء
    final hasCache = allCourses.isNotEmpty && (isGuest || myCourses.isNotEmpty);
    if (!hasCache) {
      _isLoading = true;
      _isBackgroundUpdating = false;
    } else {
      _isLoading = false;
      _isBackgroundUpdating = true;
    }
    _errorMessage = null;
    notifyListeners();

    // 3. بدء عملية جلب البيانات الجديدة في الخلفية
    try {
      if (isGuest) {
        await getCourses(showLoading: !hasCache);
        myCourses = [];
      } else {
        await Future.wait([
          getCourses(showLoading: !hasCache),
          getMyCourses(showLoading: !hasCache),
        ]);
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    } finally {
      _isLoading = false;
      _isBackgroundUpdating = false;
      notifyListeners();
      debugPrint('refreshAll completed: background sync complete');
    }
  }
}
