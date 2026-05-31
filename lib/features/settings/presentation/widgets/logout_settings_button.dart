import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LogoutSettingsButton extends StatelessWidget {
  const LogoutSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: const SettingsIconWrapper(
          icon: Icons.logout_rounded,
          color: AppColors.red,
        ),
        title: Text(
          'تسجيل الخروج',
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.red),
        onTap: () {
          AppDialog.showDynamicDialog(
            context: context,
            title: 'تسجيل الخروج',
            message: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            isError: true,
            confirmText: 'موافق',
            cancelText: 'إلغاء',
            onConfirm: () async {
              await context.read<AuthServiceProvider>().logout();
              if (context.mounted) {
                context.go(Routes.auth);
              }
            },
          );
        },
      ),
    );
  }
}
