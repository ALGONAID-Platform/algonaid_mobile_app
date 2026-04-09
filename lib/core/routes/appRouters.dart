import 'package:algonaid_mobail_app/auth_gate.dart';
import 'package:algonaid_mobail_app/core/routes/navigatorKey.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/circular_reveal.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/pages/signin_&_signup_pages.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/pages/courses_page.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

abstract class AppRouters {
  static final routers = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => AuthGate(),
      ),
      GoRoute(
        path: Routes.homePage,
        builder: (context, state) => CoursesHomePage(),
      ),
      GoRoute(
        path: Routes.auth,
        pageBuilder: (context, state) {
          final size = MediaQuery.of(context).size;
          return GreenRevealPage(
            key: state.pageKey,
            child: const SigninAndSignupPage(),
            // المركز: أسفل اليمين (نفس مكان الزر)
            center: Offset(size.width - 50, size.height - 70),
            color: AppColors.primary, // اللون الذي تريده
          );
        },
      ),
    ],
  );
}
