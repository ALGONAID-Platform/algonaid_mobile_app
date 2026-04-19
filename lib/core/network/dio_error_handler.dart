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
    if (response == null) return ServerFailure('عذراً، حدث خطأ غير معروف');

    final statusCode = response.statusCode;
    final data = response.data;

    if (data is Map && data['message'] != null) {
      var msg = data['message'];

      // NestJS أحياناً يرسل قائمة أخطاء (List) وأحياناً نص (String)
      if (msg is List) {
        return ServerFailure(msg.join('\n')); // نجمع الأخطاء في أسطر تحت بعضها
      }
      return ServerFailure(msg.toString());
    }

    // في حال لم نجد حقل message، نعتمد على الـ Status Code كخطة بديلة
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure('خطأ في البيانات أو صلاحية الدخول');
    } else if (statusCode == 404) {
      return ServerFailure('المسار المطلوب غير موجود');
    } else if (statusCode == 500) {
      return ServerFailure('خطأ داخلي في الخادم');
    }

    return ServerFailure('عذراً، حدث خطأ ما، حاول لاحقاً');
  }
}
