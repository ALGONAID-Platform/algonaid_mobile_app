// lib/core/utils/routes/router_auth_guard.dart

import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterAuthGuard {
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    final token = TokenStorage.getToken();
    final isLoggedIn = token != null;

    // تحديد المسارات التي لا تتطلب تسجيل دخول
    final isAuthPage =
        state.matchedLocation == Routes.loginPage || state.matchedLocation == Routes.signUp;

    if (!isLoggedIn) {
      // If not logged in and trying to access a protected page, redirect to login
      if (!isAuthPage && state.matchedLocation != '/') {
         return Routes.loginPage;
      }
      return null;
    }

    if (isLoggedIn) {
      // If logged in and trying to access auth pages, redirect to home
      if (isAuthPage || state.matchedLocation == '/') {
        return Routes.homePage;
      }
      return null;
    }

    return null; // No redirect needed
  }
}
