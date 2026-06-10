const port = '3000';
const ip = '192.168.1.11';

class EndPoint {
  // base url for app API
  static const String baseUrl = 'http://$ip:$port/api/v1';
  // base url for uploaded files
  static const String uploadsBaseUrl = 'http://$ip:$port/uploads/';
  // Google OAuth entry points
  static const String googleAuth = '$baseUrl/auth/google';
  static const String googleCallback = '$baseUrl/auth/google/callback';
  static const String googleMobileAuth = '$baseUrl/auth/google/mobile';

  // API endpoints
  static const String signin = '$baseUrl/auth/signin';
  static const String signup = '$baseUrl/auth/signup';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String courses = '$baseUrl/courses';
  static const String myCourses = '$baseUrl/courses/my-courses';
  static const String enrollment = '$baseUrl/enrollment';
  static const String searchCourses = '$baseUrl/courses/search';

  static String lessonsByModule(int moduleId) =>
      '$baseUrl/lessons/module/$moduleId';
  static String lessonDetails(int lessonId) => '$baseUrl/lessons/$lessonId';
  static String courseProgress(int courseId) =>
      '$baseUrl/progress/course/$courseId';
  static String modulesByCourse(int courseId) =>
      '$baseUrl/modules/course/$courseId';
  static String moduleGrades(int moduleId) =>
      '$baseUrl/progress/module/$moduleId/grades';
  static String courseGrades(int courseId) =>
      '$baseUrl/progress/course/$courseId/grades';
  static const String excellenceCourses = '$baseUrl/progress/excellence-courses';
  static const String lastAccessedModule ='$baseUrl/progress/last-accessed-module';
  static const String progressUpdate = '$baseUrl/progress/update';
  static String getExamDetails(int examId) => '$baseUrl/exams/$examId';
  static String startExam(int examId) => '$baseUrl/exams/$examId/start';
  static String submitExam(int attemptId) =>'$baseUrl/exams/attempts/$attemptId/submit';
  static String getExamResult(int attemptId) =>'$baseUrl/exams/attempts/$attemptId/result';
}
