const PORT = '3000';
const IP = '10.111.33.22';

class EndPoint {
  //base url for app API
  static const String baseUrl = 'http://$IP:$PORT/api/v1';
  // base url for uploaded files
  static const String uploadsBaseUrl = 'http://$IP:$PORT/uploads/';
  // API endpoints
  static const String signin = '$baseUrl/auth/signin';
  static const String signup = '$baseUrl/auth/signup';
  static const String courses = '$baseUrl/courses';
  static const String myCourses = '$baseUrl/courses/my-courses';
  
  static get lessonsByModuleEndpoint => null;
  
  static get lessonDetailsEndpoint => null;

  // for dynamic endpoints with parameters
  static String bookDetails(int id) => '/books/$id';
  static String lessonsByModule(int moduleId) =>
      '$lessonsByModuleEndpoint/$moduleId';
  static String lessonDetails(int lessonId) =>
      '$lessonDetailsEndpoint/$lessonId';
}
