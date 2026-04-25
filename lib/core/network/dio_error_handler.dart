import 'package:algonaid_mobail_app/core/errors/failure.dart';
import 'package:dio/dio.dart';

class DioErrorHandler {
  // جعلنا الدالة static حتى نستدعيها مباشرة دون إنشاء كائن من الكلاس
  static Failure handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure('استغرق الاتصال وقتاً أطول من المتوقع. حاول مرة أخرى.');

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.connectionError:
        return ConnectionFailure('لا يوجد اتصال بالإنترنت. تأكد من الشبكة ثم حاول مرة أخرى.');

      case DioExceptionType.cancel:
        return ServerFailure('تم إيقاف الطلب. حاول مرة أخرى.');

      case DioExceptionType.unknown:
      default:
        return ServerFailure('حدثت مشكلة غير متوقعة. حاول مرة أخرى.');
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
        return ServerFailure(msg.isNotEmpty ? msg.first.toString() : 'تعذر إكمال الطلب حالياً.');
      }
      return ServerFailure(msg.toString());
    }

    // في حال لم نجد حقل message، نعتمد على الـ Status Code كخطة بديلة
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure('تعذر إكمال الطلب. تحقق من البيانات ثم حاول مرة أخرى.');
    } else if (statusCode == 404) {
      return ServerFailure('المحتوى المطلوب غير متوفر حالياً.');
    } else if (statusCode == 500) {
      return ServerFailure('حدثت مشكلة في الخادم. حاول مرة أخرى بعد قليل.');
    }

    return ServerFailure('عذراً، حدث خطأ ما، حاول لاحقاً');
  }
}
