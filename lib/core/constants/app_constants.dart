import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:flutter/material.dart';

abstract class AppConstants {
  static const String appName = 'Bookly';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A book reading application';

  //localization
  static const String arabicLang = 'ar';
  static const String englishLang = 'en';
  static const String defaultLang = 'en';
  static const List<String> supportedLocales = ['en', 'ar'];

  //Hive box names
  static const String boxAuthTokenName = 'auth_token_box';
  static const String tokenKey = 'auth_token';
  static const String boxCourses = "courses_box";
  static const String boxMyCourses = "my_courses_box";
  static const String boxCourseProgress = "course_progress_box";
  static const String boxLastAccessedModule = "boxLastAccessedModule";
  static const String boxLessons = "lessons_box";
  static const String boxLessonDetails = "lesson_details_box";
  static const String boxModules = "modules_box";
  static const String boxExams = "exams_box";
  static const String boxExamResults = "exam_results_box";
  static const String boxFeaturedTrendinBooks = "featured_trending_books";
  static const String boxFeaturedTopRatedBooks = "featured_top_rated_books";
  static const String boxFeaturedQuickReadBooks = "featured_quick_read_books";
  static const String boxReadingProgress = "reading_progress_box";
  static const String boxLessonProgress = "lesson_progress_box";

  // shared preferences keys
  static const String token = 'TOKEN';
  static const String language = 'LANGUAGE';
  static const String theme = 'THEME';
  static const String onBoarding = 'ON_BOARDING';
  static const String userId = 'k_user_id';
  static const String userName = 'k_user_name';
  static const String userEmail = 'k_user_email';
  static const String userRole = 'k_user_role';
  static const String userAvatar = 'k_user_avatar';
  static const String userBackground = 'k_user_background';
  static const String userAcademicId = 'k_user_academic_id';
  static const String userGrade = 'k_user_grade';
  static const String userAddress = 'k_user_address';
  static const String userBirthDate = 'k_user_birth_date';
  static const String userCreatedAt = 'k_user_created_at';
  static const String userUpdatedAt = 'k_user_updated_at';
  static const String isFirstTime = 'k_is_first_time';
  static const String isDark = "isDark";
  static const String cacheModuleGradesPrefix = 'module_grades_';
  static const String cacheCourseGradesPrefix = 'course_grades_';
  static const String cacheTotalPoints = 'cache_total_points';
  static const String cacheUserProfile = 'cache_user_profile';
  static const String cacheExcellenceCourses = 'cache_excellence_courses';

  static const String enableNotifications = 'enableNotifications';
  static const String floatingVideo = 'floatingVideo';
  static const String autoPlayNext = 'autoPlayNext';
  static const String downloadQuality = 'downloadQuality';
  static const String videoLocalPathPrefix = 'video_local_path_';
  static const String pdfLocalPathPrefix = 'pdf_local_path_';

  //validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  //pagination
  static const int itemsPerPage = 10; // limit
  static const int defaultPageNumber = 1;
  static const int maxPageSize = 100;

  // api timeouts
  static const Duration apiConnectTimeout = Duration(seconds: 15);
  static const Duration apiReceiveTimeout = Duration(seconds: 5);
  static const Duration apiSendTimeout = Duration(seconds: 5);

  //responsive screens
  static const double mobileBreakpoint = 700;
  static const double tabletBreakpoint = 1000;

  // screen width and hieght

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakpoint &&
      MediaQuery.sizeOf(context).width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  // flexible numbers
  static const detailsPageFlex = 4;
  static const mobilePageFlex = 5;
  static const drawBarPageFlex = 2;

  // user data
  static int userIdValue = int.tryParse(
    CacheHelper.getString(key: AppConstants.userId)!,
  )!;
  static String userNameValue = CacheHelper.getString(
    key: AppConstants.userName,
  )!;
  static String userEmailValue = CacheHelper.getString(
    key: AppConstants.userEmail,
  )!;

  //color dark matrix for pdf viewer
  static const colorFilter = ColorFilter.matrix([
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);

  //Grid view rows and columns
  static int getGridViewRows(BuildContext context) {
    if (isMobile(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 3;
    }
  }

  static int getGridViewColumns(BuildContext context) {
    if (isMobile(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 4;
    } else {
      return 5;
    }
  }
}
