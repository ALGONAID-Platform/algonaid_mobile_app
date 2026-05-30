import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/network/check_internet.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        if (e.response?.statusCode == 401) {
          debugPrint('Dio Interceptor: Received 401 Unauthorized.');
          final token = TokenStorage.getToken();
          final isGuest = token == null || token.trim().isEmpty;
          
          await TokenStorage.deleteToken();
          
          final context = navigatorKey.currentContext;
          if (context != null) {
            GoRouter.of(context).go(Routes.auth);
            AppSnackBar.show(
              context: context,
              message: isGuest ? 'يرجى تسجيل الدخول للقيام بهذه العملية' : 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً',
              type: SnackBarType.error,
            );
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
