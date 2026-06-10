import 'package:algonaid_mobile_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/utils/hive/token_storage.dart';
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
    router.go(Routes.guestHome);
    return;
  }

  bool isExpired = false;
  try {
    if (token.contains('.')) {
      isExpired = JwtDecoder.isExpired(token);
    } else {
      debugPrint(
        'checkUserAuth: Token is not in JWT format (no dots). Treating as not expired.',
      );
      isExpired = false;
    }
  } catch (e) {
    debugPrint(
      'checkUserAuth: Error checking JWT expiration: $e. Treating as not expired.',
    );
    isExpired = false;
  }

  if (isExpired) {
    await TokenStorage.deleteToken();
    router.go(Routes.guestHome);
    return;
  }

  router.go(Routes.homePage);
}
