const PORT = '3000';
const IP = '172.24.96.1';

class EndPoint {
  //base url for app API
  static const String baseUrl = 'http://$IP:$PORT/api/v1';
  // base url for uploaded files
  static const String uploadsBaseUrl = 'http://$IP:$PORT/uploads/';
  // API endpoints
  static const String signin = '$baseUrl/auth/signin';
  static const String signup = '$baseUrl/auth/signup';

  // for dynamic endpoints with parameters
  static String bookDetails(int id) => '/books/$id';
}
