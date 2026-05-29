import 'package:algonaid_mobail_app/core/errors/exceptions.dart';
import 'package:algonaid_mobail_app/core/network/dio_error_handler.dart';
import 'package:dio/dio.dart';

Future<dynamic> performRequest(Future<Response> requestFunc) async {
  try {
    final response = await requestFunc;
    // التحقق من نجاح الرد
    if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
      return response.data;
    } else {
      throw ServerException('استجابة غير صحيحة: ${response.statusCode}');
    }
  } on DioException catch (e) {
    // 1. نستخرج رسالة الخطأ من الهاندلر
    final failure = DioErrorHandler.handle(e);

    // 2. 🛑 التعديل الأهم: نرميها كـ Exception وليس Failure
    throw ServerException(failure.message);
  } catch (e) {
    // التقاط أخطاء الكود (مثل null check operator)
    throw ServerException(e.toString());
  }
}
