import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid_mobile_app/core/network/check_internet.dart';
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
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.red,
        ),
        onTap: () {
          AppDialog.showDynamicDialog(
            context: context,
            title: 'تسجيل الخروج',
            message: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            isError: true,
            confirmText: 'موافق',
            cancelText: 'إلغاء',
            onConfirm: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext c) => const Center(child: CircularProgressIndicator()),
              );

              final isOffline = await hasNoInternet();
              if (isOffline) {
                if (context.mounted) {
                  Navigator.pop(context); // dismiss loading
                  AppDialog.showDynamicDialog(
                    context: context,
                    title: 'لا يوجد اتصال',
                    message: 'يرجى التأكد من اتصالك بالإنترنت لتتمكن من تسجيل الخروج وإزالة الجلسة بشكل آمن.',
                    isError: true,
                    confirmText: 'حسناً',
                    showCancelButton: false,
                    onConfirm: () {},
                  );
                }
                return;
              }

              if (context.mounted) {
                context.read<ProfileProvider>().clearProfileData();
                context.read<LastAccessedModuleProvider>().clearData();
              }
              
              final authProvider = context.read<AuthServiceProvider>();
              await authProvider.logout();
              
              if (context.mounted) {
                Navigator.pop(context); // dismiss loading
                if (authProvider.user == null) {
                  context.go(Routes.auth);
                } else if (authProvider.errorMessage != null) {
                  AppDialog.showDynamicDialog(
                    context: context,
                    title: 'خطأ',
                    message: authProvider.errorMessage ?? 'حدث خطأ غير متوقع',
                    isError: true,
                    confirmText: 'حسناً',
                    showCancelButton: false,
                    onConfirm: () {},
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
