import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:algonaid_mobile_app/core/theme/theme.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/theme/theme_provider.dart'
    as app_theme;

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(text: 'الإعدادات العامة'),
            const SizedBox(height: 12),

            // المجموعة الأولى: إعدادات التطبيق الأساسية
            _buildSettingsContainer(
              context,
              children: [
                ListTile(
                  leading: _buildIconTile(
                    context,
                    context.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    context.isDarkMode ? AppColors.amber : AppColors.primary,
                  ),
                  title: Text(
                    'الوضع الليلي',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: ThemeSwitcher(
                    builder: (context) {
                      return IconButton(
                        key: const GlobalObjectKey('theme_button'),
                        icon: Icon(
                          context.isDarkMode
                              ? Icons.toggle_on_rounded
                              : Icons.toggle_off_rounded,
                          size: 40,
                          color: context.isDarkMode
                              ? AppColors.amber
                              : Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () {
                          final themeProv = context
                              .read<app_theme.ThemeProvider>();
                          final isNewModeDark = !context.isDarkMode;

                          // Update provider state and cache
                          themeProv.toggleTheme(isNewModeDark);

                          // Trigger theme switch animation with preserved color/font settings
                          ThemeSwitcher.of(context).changeTheme(
                            theme: isNewModeDark
                                ? ThemeApp.getDarkTheme(
                                    colorIndex: themeProv.colorIndex,
                                    fontIndex: themeProv.fontIndex,
                                  )
                                : ThemeApp.getLightTheme(
                                    colorIndex: themeProv.colorIndex,
                                    fontIndex: themeProv.fontIndex,
                                  ),
                            isReversed: context.isDarkMode,
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.settings_rounded,
                  iconColor: Colors.blueGrey,
                  title: 'إعدادات متقدمة',
                  onTap: () {
                    context.push(Routes.settingsPage);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // حاوية مخصصة للمجموعات لتعطي شكل البطاقات الأنيقة ذات الحواف الناعمة والظلال
  Widget _buildSettingsContainer(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: AppBorder.main_border,
      ),
      child: Column(children: children),
    );
  }

  // بناء أسطر الخيارات بشكل موحد واحترافي سريعاُ
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: _buildIconTile(context, icon, iconColor),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: context.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  // بناء الحاوية الصغيرة الملونة للأيقونات الجانبية لتعطي عمق بصري رائع
  Widget _buildIconTile(
    BuildContext context,
    IconData icon,
    Color color, {
    bool isDanger = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDanger
            ? AppColors.red.withOpacity(0.12)
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, color: AppColors.divider.withOpacity(0.3)),
    );
  }
}
