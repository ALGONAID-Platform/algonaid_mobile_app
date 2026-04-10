import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/hive/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // 🌟 أضف هذا السطر

Future<void> checkUserAuth() async {
  // 1. قراءة التوكن من الذاكرة (تأكد أن getToken ليست Future وإلا أزل await)
  String? token = TokenStorage.getToken();

  // تأخير بسيط لمنع القفز المفاجئ بين الشاشات
  await Future.delayed(const Duration(seconds: 2));

  // الحصول على السياق (Context) من المفتاح العالمي
  final context = navigatorKey.currentContext;

  // 🌟 بدلاً من mounted، نفحص إذا كان الـ context موجوداً
  if (context == null) return;

  if (token == null) {
    // 2. لا يوجد توكن -> اذهب لتسجيل الدخول
    GoRouter.of(context).go(Routes.auth);
    return;
  }

  bool isTokenExpired = JwtDecoder.isExpired(token);

  if (isTokenExpired) {
    await TokenStorage.deleteToken();
    if (context.mounted) {
      GoRouter.of(context).go(Routes.auth);
    }
  } else {
    GoRouter.of(context).go(Routes.homePage);
  }
}
