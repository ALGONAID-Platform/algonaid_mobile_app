import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart'; // New Import
import 'package:algonaid_mobail_app/core/constants/app_constants.dart'; // New Import
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> checkUserAuth() async {
  String? token = TokenStorage.getToken();
  await Future.delayed(const Duration(seconds: 2));
  final context = navigatorKey.currentContext;

  if (context == null) return;

  // Check onboarding status
  bool? onBoardingIsViewed = CacheHelper.getBool(key: AppConstants.onBoarding);

  if (token == null) {
    // If no token, go to auth (sign-in/sign-up)
    GoRouter.of(context).go(Routes.auth);
    return;
  }

  // If token exists, check if it's expired
  bool isTokenExpired = JwtDecoder.isExpired(token);

  if (isTokenExpired) {
    await TokenStorage.deleteToken();
    if (context.mounted) {
      GoRouter.of(context).go(Routes.auth);
    }
  } else {
    // If token is valid, check if onboarding has been viewed
    if (onBoardingIsViewed == null || !onBoardingIsViewed) {
      // If onboarding not viewed, go to onboarding screen
      GoRouter.of(context).go(Routes.onboarding);
    } else {
      // If onboarding viewed, go to home page
      GoRouter.of(context).go(Routes.homePage);
    }
  }
}
