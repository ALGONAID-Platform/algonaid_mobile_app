import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> checkUserAuth([BuildContext? buildContext]) async {
  final context = buildContext ?? navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  final router = GoRouter.of(context);

  final token = TokenStorage.getToken();
  if (token == null || token.trim().isEmpty) {
    final hasSeenOnboarding = CacheHelper.getBool(key: AppConstants.onBoarding) ?? false;
    if (!hasSeenOnboarding) {
      router.go(Routes.onboarding);
    } else {
      router.go(Routes.auth);
    }
    return;
  }

  if (JwtDecoder.isExpired(token)) {
    await TokenStorage.deleteToken();
    router.go(Routes.auth);
    return;
  }

  router.go(Routes.homePage);
}
