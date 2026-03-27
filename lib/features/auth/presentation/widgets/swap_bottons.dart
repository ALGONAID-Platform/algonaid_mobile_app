// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';

import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

// ignore: must_be_immutable
class SwapAuthButtonCostum extends StatelessWidget {
  AuthServiceProvider auth;
  SwapAuthButtonCostum({super.key, required this.auth});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(bottom: 48),
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: StackButtons(auth: auth),
    );
  }
}

// ignore: must_be_immutable
class StackButtons extends StatelessWidget {
  AuthServiceProvider auth;

  StackButtons({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: auth.isLogin
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            height: 59,
            padding: EdgeInsets.all(5),
            width: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // to unFocus fields
                    if (!auth.isLogin) auth.toggleAuthMode();
                  },
                  child: Text(
                    "تسجيل دخول",
                    style: Styles.textStyle16.copyWith(
                      color: AppColors.bgLight,
                    ),
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // to unFocus fields
                    if (auth.isLogin) auth.toggleAuthMode();
                  },
                  child: Text(
                    "أنشاء حساب",
                    style: Styles.textStyle16.copyWith(
                      color: AppColors.bgLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
