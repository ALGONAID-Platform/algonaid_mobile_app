import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = CacheHelper.getString(key: AppConstants.userName) ?? "مستخدم";
    final userEmail = CacheHelper.getString(key: AppConstants.userEmail) ?? "user@example.com";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: context.textTheme.displayMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: context.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
