import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dio/dio.dart';

class DioErrorHandler {
  // جعلنا الدالة static حتى نستدعيها مباشرة دون إنشاء كائن من الكلاس
  static Failure handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Connection Timeout with ApiServer');

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
        
      case DioExceptionType.connectionError:
        return ConnectionFailure('No Internet Connection');
        
      case DioExceptionType.cancel:
        return ServerFailure('Request to API server was cancelled');
        
      case DioExceptionType.unknown:
      default:
        return ServerFailure('Opps There was an Unknown Error');
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return ServerFailure('Unknown Error');
    final statusCode = response.statusCode;
    final data = response.data;

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      if (data is Map && data['error'] != null) {
         // هنا نفترض أن الباك اند يرسل الخطأ بهذا الشكل، عدلها حسب الـ API الخاص بك
         return ServerFailure(data['error']['message'] ?? 'Authentication Error');
      }
    }
    if (statusCode == 404) return ServerFailure('Request Not Found');
    if (statusCode == 500) return ServerFailure('Internal Server Error');

    return ServerFailure('Opps There was an Error');
  }
}