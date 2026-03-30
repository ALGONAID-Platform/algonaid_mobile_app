const PORT = '3000';
const IP = '127.0.0.1';

class EndPoint {
  // Base url for app API
  static const String baseUrl = 'http://$IP:$PORT/api/v1';
  // Base url for uploaded files 
  static const String uploadsBaseUrl = 'http://$IP:$PORT/uploads/';
  // API endpoints
  static const String bookurl = '$uploadsBaseUrl/books/smart.pdf';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String booksEndpoint = '/books';
  static const String trendingBooksEndpoint = '/books/trendingBooks';
  static const String newsBooksEndpoint = '/books/newsBooks';
  static const String quickReadEndpoint = '/books/quickRead';
  static const String topRatedBooksEndpoint = '/books/topRatedBooks';
  static const String bookDetailsEndpoint = '/books/{id}';
  static const String updateProgressEndpoint = '/reading-progress';
  static const String lastReadEndpoint = '/reading-progress';
  static const String searchBooks = '/books/search';
  static const String lessonsByModuleEndpoint = '/lessons/module';
  static const String lessonDetailsEndpoint = '/lessons';

// For dynamic endpoints with parameters 
  static String bookDetails(int id) => '/books/$id';
  static String lessonsByModule(int moduleId) =>
      '$lessonsByModuleEndpoint/$moduleId';
  static String lessonDetails(int lessonId) =>
      '$lessonDetailsEndpoint/$lessonId';
}
