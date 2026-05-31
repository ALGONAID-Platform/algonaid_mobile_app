import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/theme/theme_provider.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart' hide ThemeProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsSection extends StatelessWidget {
  const AppearanceSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'المظهر'),
        ListTile(
          leading: SettingsIconWrapper(
            icon: Icons.color_lens_rounded,
            color: context.primary,
          ),
          title: Text(
            'لون التطبيق الأساسي',
            style: context.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'تغيير لون التطبيق إلى لونك المفضل',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => _showColorPickerBottomSheet(context),
        ),
        ListTile(
          leading: SettingsIconWrapper(
            icon: Icons.font_download_rounded,
            color: context.primary,
          ),
          title: Text(
            'خط التطبيق',
            style: context.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'تغيير نوع الخط المستخدم في التطبيق',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => _showFontPickerBottomSheet(context),
        ),
      ],
    );
  }

  void _showColorPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final themeProvider = context.watch<ThemeProvider>();
        return ThemeSwitcher(
          builder: (switcherContext) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر لون التطبيق',
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(ThemeApp.availableColors.length, (index) {
                        final color = ThemeApp.availableColors[index];
                        final isSelected = themeProvider.colorIndex == index;
                        return GestureDetector(
                          onTap: () {
                            themeProvider.changeColor(index);
                            ThemeSwitcher.of(switcherContext).changeTheme(
                              theme: context.isDarkMode
                                  ? ThemeApp.getDarkTheme(colorIndex: index, fontIndex: themeProvider.fontIndex)
                                  : ThemeApp.getLightTheme(colorIndex: index, fontIndex: themeProvider.fontIndex),
                            );
                            context.pop();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: context.textTheme.bodyLarge?.color ?? Colors.black, width: 3)
                                  : null,
                            ),
                            child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFontPickerBottomSheet(BuildContext context) {
    final List<String> fontNames = [
      'الخط الافتراضي (IBM Plex Sans)',
      'خط كايرو (Cairo)',
      'خط تجوال (Tajawal)',
      'خط المراعي (Almarai)',
      'خط تشانجا (Changa)'
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final themeProvider = context.watch<ThemeProvider>();
        return ThemeSwitcher(
          builder: (switcherContext) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر خط التطبيق',
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(ThemeApp.availableFonts.length, (index) {
                      return ListTile(
                        title: Text(fontNames[index], style: TextStyle(fontFamily: ThemeApp.availableFonts[index])),
                        trailing: themeProvider.fontIndex == index ? Icon(Icons.check_circle, color: context.primary) : null,
                        onTap: () {
                          themeProvider.changeFont(index);
                          ThemeSwitcher.of(switcherContext).changeTheme(
                            theme: context.isDarkMode
                                ? ThemeApp.getDarkTheme(colorIndex: themeProvider.colorIndex, fontIndex: index)
                                : ThemeApp.getLightTheme(colorIndex: themeProvider.colorIndex, fontIndex: index),
                          );
                          context.pop();
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
