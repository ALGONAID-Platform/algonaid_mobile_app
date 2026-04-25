import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(text: 'الإعدادات'),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'الوضع الليلي',
                      style: context.textTheme.bodyLarge,
                    ),
                    trailing: ThemeSwitcher(
                      builder: (context) {
                        return IconButton(
                          key: const GlobalObjectKey('theme_button'),
                          icon: Icon(
                            context.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: context.isDarkMode
                                ? AppColors.amber
                                : AppColors.primary,
                          ),
                          onPressed: () {
                            ThemeSwitcher.of(context).changeTheme(
                              theme: context.isDarkMode
                                  ? ThemeApp.lightTheme
                                  : ThemeApp.darkTheme,
                              isReversed: context.isDarkMode,
                            );

                            CacheHelper.saveData(
                              key: 'isDarkMode',
                              value: !context.isDarkMode,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: AppColors.primary,
                    ),
                    title: Text('اللغة', style: context.textTheme.bodyLarge),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implement language change
                    },
                  ),
                  Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.red),
                    title: Text(
                      'تسجيل الخروج',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                    onTap: () async {
                      // Call logout in AuthServiceProvider
                      await context.read<AuthServiceProvider>().logout();

                      // Navigate back to the auth page
                      if (context.mounted) {
                        context.go(Routes.auth);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
