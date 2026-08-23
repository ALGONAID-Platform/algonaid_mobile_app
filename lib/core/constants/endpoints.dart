import 'package:flutter/foundation.dart';

const port = '3000';
const ip = '10.229.154.22';


class EndPoint {  

// base url for app API
//   static String get baseUrl => kDebugMode
//       ? 'http://$ip:$port/api/v1'
//       : 'https://api.exchangesmangement.online/api/v1';

static String get baseUrl => 'https://api.exchangesmangement.online/api/v1';

  // base url for uploaded files
static String get uploadsBaseUrl => kDebugMode
      ? 'http://$ip:$port/uploads/'
      : 'https://api.exchangesmangement.online/uploads/';


  // Google OAuth entry points
  static String get googleAuth => '$baseUrl/auth/google';
  static String get googleCallback => '$baseUrl/auth/google/callback';
  static String get googleMobileAuth => '$baseUrl/auth/google/mobile';


  // API endpoints
  static String get signin => '$baseUrl/auth/signin';
  static String get signup => '$baseUrl/auth/signup';
  static String get logout => '$baseUrl/auth/logout';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get resetPassword => '$baseUrl/auth/reset-password';
  static String get validateResetToken => '$baseUrl/auth/validate-reset-token';

  // Email Verification endpoints
  static String get verifyEmail => '$baseUrl/auth/verify-email';
  static String get resendVerification => '$baseUrl/auth/resend-verification';
  static String get courses => '$baseUrl/courses';
  static String get myCourses => '$baseUrl/courses/my-courses';
  static String get enrollment => '$baseUrl/enrollment';
  static String get searchCourses => '$baseUrl/courses/search';

  static String lessonsByModule(int moduleId, {int page = 1, int limit = 10}) =>
      '$baseUrl/lessons/module/$moduleId?page=$page&limit=$limit';
  static String lessonsByModuleGuest(int moduleId, {int page = 1, int limit = 10}) =>
      '$baseUrl/lessons/module/$moduleId/guest?page=$page&limit=$limit';
  static String lessonDetails(int lessonId) => '$baseUrl/lessons/$lessonId';
  static String courseProgress(int courseId) =>
      '$baseUrl/progress/course/$courseId';
  static String modulesByCourse(int courseId) =>
      '$baseUrl/modules/course/$courseId';
  static String modulesByCourseGuest(int courseId) =>
      '$baseUrl/modules/course/$courseId/guest';
  static String moduleGrades(int moduleId) =>
      '$baseUrl/progress/module/$moduleId/grades';
  static String courseGrades(int courseId) =>
      '$baseUrl/progress/course/$courseId/grades';
  static String get excellenceCourses => '$baseUrl/progress/excellence-courses';
  static String get lastAccessedModule => '$baseUrl/progress/last-accessed-module';
  static String get progressUpdate => '$baseUrl/progress/update';
  static String getExamDetails(int examId) => '$baseUrl/exams/$examId';
  static String startExam(int examId) => '$baseUrl/exams/$examId/start';
  static String submitExam(int attemptId) => '$baseUrl/exams/attempts/$attemptId/submit';
  static String getExamResult(int attemptId) => '$baseUrl/exams/attempts/$attemptId/result';
  static String practiceExamsByCourse(int courseId) => '$baseUrl/practice-exams/course/$courseId';

}
