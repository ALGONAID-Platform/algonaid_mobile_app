import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/check_internet.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void initializeDio(Dio dio) {
  dio.options
    ..baseUrl = EndPoint.baseUrl
    ..connectTimeout = AppConstants.apiConnectTimeout
    ..receiveTimeout = AppConstants.apiReceiveTimeout
    ..sendTimeout = kIsWeb ? null : AppConstants.apiSendTimeout
    ..headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${TokenStorage.getToken() ?? ''}', // Reintroduced initial Authorization header setup
    };

    dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('Dio Interceptor: Checking internet connection...');
        // فحص النت
        if (await hasNoInternet()) {
          debugPrint('Dio Interceptor: No internet connection detected. Rejecting request.');
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'لا يوجد اتصال بالإنترنت',
              type: DioExceptionType.connectionError,
            ),
          );
        }
        debugPrint('Dio Interceptor: Internet connection available.');

        // التوكن
        final token = TokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
      

        // 2. مهم جداً: تمرير الخطأ لباقي التطبيق (الريبو) مهما كان نوعه!
        // بدون هذا السطر، أي خطأ غير 401 سيجعل التطبيق يعلق للأبد
        return handler.next(e);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
  }
}
