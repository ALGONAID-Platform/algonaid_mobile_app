const PORT = '3000';
const IP = '172.24.96.1';

class EndPoint {
  // Base url for app API
  static const String baseUrl = 'http://$IP:$PORT/api/v1';
  // Base url for uploaded files
  static const String uploadsBaseUrl = 'http://$IP:$PORT/uploads/';
  // API endpoints
  static const String signin = '$baseUrl/auth/signin';
  static const String signup = '$baseUrl/auth/signup';

  // For dynamic endpoints with parameters
  static String bookDetails(int id) => '/books/$id';
  static String lessonsByModule(int moduleId) =>
      '$baseUrl/modules/$moduleId/lessons';
  static String lessonDetails(int lessonId) => '$baseUrl/lessons/$lessonId';
}
