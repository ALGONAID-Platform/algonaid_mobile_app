// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:algonaid_mobile_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobile_app/core/utils/functions/user_friendly_error.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';

// ignore: must_be_immutable
class SignInWithGoogle extends StatelessWidget {
  AuthServiceProvider auth;
  SignInWithGoogle({Key? key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: auth.isLoading
          ? null
          : () async {
              await auth.loginWithGoogle();

              if (!context.mounted) {
                return;
              }

              if (auth.user != null) {
                GoRouter.of(context).go(Routes.homePage);
              } else if (auth.errorMessage != null) {
                AppDialog.showDynamicDialog(
                  context: context,
                  title: "تعذر تسجيل الدخول",
                  message: toUserFriendlyErrorMessage(auth.errorMessage),
                  isError: true,
                  showCancelButton: false,
                  confirmText: "حاول مرة أخرى",
                );
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.surfaceContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: context.primary, width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SVG.googleSvg, width: 20, height: 20),
            const SizedBox(width: 10),
            auth.isLogin
                ? TextLabel(text: "سجل الدخول عن طريق جوجل")
                : TextLabel(text: "إنشاء حساب عن طريق جوجل"),
          ],
        ),
      ),
    );
  }
}
