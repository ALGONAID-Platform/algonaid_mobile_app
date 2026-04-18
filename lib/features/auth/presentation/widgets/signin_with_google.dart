// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';

// ignore: must_be_immutable
class SignInWithGoogle extends StatelessWidget {
  AuthServiceProvider auth;
  SignInWithGoogle({Key? key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(SVG.googleSvg, width: 20, height: 20),
          SizedBox(width: 10),
          auth.isLogin
              ? TextLabel(text: "سجل الدخول عن طريق جوجل")
              : TextLabel(text: "انشاء حساب عن طريق جوجل"),
        ],
      ),
    );
  }
}
