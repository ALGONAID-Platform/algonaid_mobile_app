
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/check_internet.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart'; 

void initialiseDio(Dio dio) {
  dio.options
    ..baseUrl = EndPoint.baseUrl
    ..connectTimeout = AppConstants.apiConnectTimeout // خليها 5 ثواني أفضل من 1
    ..receiveTimeout = AppConstants.apiReceiveTimeout
    ..sendTimeout =kIsWeb ? null :  AppConstants.apiSendTimeout
    ..headers = {
      'Content-Type': 'application/json',
    };

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // فحص النت
        if (await hasNoInternet()) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'لا يوجد اتصال بالإنترنت',
              type: DioExceptionType.connectionError,
            ),
          );
        }

        // التوكن
        final token = TokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final context = navigatorKey.currentContext;
          if (context != null) {
            // GoRouter.of(context).go(Routes.loginPage);
          }
        }

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