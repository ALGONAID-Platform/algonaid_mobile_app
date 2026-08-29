abstract class Routes {
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String homePage = "/homePage";
  static const String guestHome = "/guestHome";
  static const String modulesList = '/modulesList';
  static const String lessonDetails = '/lessonDetails';
  static const String lessonsList = '/lessonsList';
  static const String coursesPage = '/coursesPage';
  static const String examPage = '/examPage';
  static const String searchPage = '/searchPage';
  static const String notificationsPage = '/notificationsPage';
  static const String aboutPage = '/aboutPage';
  static const String developersPage = '/developersPage';
  static const String settingsPage = '/settingsPage';
  static const String policiesPage = '/policiesPage';
  static const String allExcellenceCourses = '/allExcellenceCourses';
  static const String coursesViewAllPage = '/coursesViewAllPage';
  static const String allBadgesPage = '/allBadgesPage';
  static const String aboutTeacherPage = '/aboutTeacherPage';
  static const String resetPassword = '/reset-password';

  // ==================== Email Verification Routes ====================
  /// صفحة "تحقق من بريدك الإلكتروني" — تظهر بعد التسجيل مباشرةً
  static const String emailVerification = '/email-verification';

  /// صفحة "تم التحقق بنجاح" — تظهر بعد نجاح التحقق
  static const String emailVerifiedSuccess = '/email-verified-success';

  /// صفحة "رابط التحقق منتهي الصلاحية أو غير صالح"
  static const String emailVerifyFailed = '/email-verify-failed';
}
