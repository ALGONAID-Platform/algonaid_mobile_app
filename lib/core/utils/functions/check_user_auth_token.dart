import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart'; // New Import
import 'package:algonaid_mobail_app/core/constants/app_constants.dart'; // New Import
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> checkUserAuth() async {
  // Force delete token and go to auth for testing
  await TokenStorage.deleteToken();
  final context = navigatorKey.currentContext;
  if (context != null) {
    GoRouter.of(context).go(Routes.auth);
  }
  return; // Exit early
}
