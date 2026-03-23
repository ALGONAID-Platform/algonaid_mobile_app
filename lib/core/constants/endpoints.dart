const PORT = '3000';
 const IP = '127.0.0.1';

class EndPoint {
  //base url for app API
  static const String baseUrl = 'http://$IP:$PORT/api/v1';
  // base url for uploaded files 
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

// for dynamic endpoints with parameters 
  static String bookDetails(int id) => '/books/$id';
}
