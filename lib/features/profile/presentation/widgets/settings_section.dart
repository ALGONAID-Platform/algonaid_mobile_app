import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإعدادات',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: Text(
                        'الوضع الليلي',
                        style: context.textTheme.bodyLarge,
                      ),
                      secondary: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: themeProvider.isDarkMode ? AppColors.amber : AppColors.primary,
                      ),
                      value: themeProvider.isDarkMode,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    );
                  },
                ),
                Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text(
                    'اللغة',
                    style: context.textTheme.bodyLarge,
                  ),
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
                    style: context.textTheme.bodyLarge?.copyWith(color: AppColors.red),
                  ),
                  onTap: () {
                    // TODO: Implement logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
