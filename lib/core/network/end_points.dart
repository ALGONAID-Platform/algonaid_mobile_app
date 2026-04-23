// algonaid_mobail_app/lib/core/network/end_points.dart
class EndPoint {
  static const String baseUrl = 'http://localhost:3000/api/v1'; // Adjust as needed

  static String lessonsByModule(int moduleId) => '/modules/$moduleId';
  static String lessonDetails(int lessonId) => '/lessons/$lessonId';
  static String getExamDetails(int examId) => '/exams/$examId';
  static String startExam(int examId) => '/exams/$examId/start';
  static String submitExam(int attemptId) => '/exams/attempts/$attemptId/submit';
  static String getExamResult(int attemptId) => '/exams/attempts/$attemptId/result';
}
