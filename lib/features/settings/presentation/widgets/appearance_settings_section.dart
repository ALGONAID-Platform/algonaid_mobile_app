import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/theme.dart';
import 'package:algonaid/core/theme/theme_provider.dart';
import 'package:algonaid/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart' hide ThemeProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsSection extends StatelessWidget {
  const AppearanceSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (themeContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SettingsSectionTitle(title: 'المظهر'),
            ListTile(
              leading: SettingsIconWrapper(
                icon: Icons.color_lens_rounded,
                color: themeContext.primary,
              ),
              title: Text(
                'لون التطبيق الأساسي',
                style: themeContext.textTheme.bodyLarge,
              ),
              subtitle: Text(
                'تغيير لون التطبيق إلى لونك المفضل',
                style: themeContext.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showColorPickerBottomSheet(themeContext),
            ),
            ListTile(
              leading: SettingsIconWrapper(
                icon: Icons.font_download_rounded,
                color: themeContext.primary,
              ),
              title:
                  Text('خط التطبيق', style: themeContext.textTheme.bodyLarge),
              subtitle: Text(
                'تغيير نوع الخط المستخدم في التطبيق',
                style: themeContext.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showFontPickerBottomSheet(themeContext),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final themeProvider = sheetContext.read<ThemeProvider>();
        int tempSelectedColorIndex = themeProvider.colorIndex;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'اختر لون التطبيق',
                      style: sheetContext.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(
                        ThemeApp.availableColors.length,
                        (index) {
                          final color = ThemeApp.availableColors[index];
                          final isSelected = tempSelectedColorIndex == index;
                          return GestureDetector(
                            onTap: () => setModalState(
                                () => tempSelectedColorIndex = index),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: sheetContext.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: sheetContext.isDarkMode
                                    ? Colors.white24
                                    : Colors.black12,
                              ),
                            ),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sheetContext.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final selectedIndex = tempSelectedColorIndex;

                              // 1) شغّل انيميشن الدائرة أولاً
                              ThemeSwitcher.of(parentContext).changeTheme(
                                theme: themeProvider.isDarkMode
                                    ? ThemeApp.getDarkTheme(
                                        colorIndex: selectedIndex,
                                        fontIndex: themeProvider.fontIndex,
                                      )
                                    : ThemeApp.getLightTheme(
                                        colorIndex: selectedIndex,
                                        fontIndex: themeProvider.fontIndex,
                                      ),
                              );

                              // 2) حدّث الـ provider بتأخير بسيط لتجنب الوميض المفاجئ
                              Future.delayed(const Duration(milliseconds: 120), () {
                                themeProvider.changeColor(selectedIndex);
                              });

                              Navigator.of(sheetContext).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeApp
                                  .availableColors[tempSelectedColorIndex],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'حفظ وتطبيق',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFontPickerBottomSheet(BuildContext parentContext) {
    final List<String> fontDisplayNames = [
      'الخط الافتراضي (IBM Plex Sans)',
      'خط كايرو (Cairo)',
      'خط تجوال (Tajawal)',
      'خط المراعي (Almarai)',
      'خط تشانجا (Changa)',
    ];

    showModalBottomSheet(
      context: parentContext,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        // استخدم watch لتتحدث علامة الاختيار عند التغيير
        final themeProvider = sheetContext.watch<ThemeProvider>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر خط التطبيق',
                  style: sheetContext.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...List.generate(ThemeApp.availableFonts.length, (index) {
                  final isSelected = themeProvider.fontIndex == index;
                  return ListTile(
                    title: Text(
                      fontDisplayNames[index],
                      style: TextStyle(
                        fontFamily: ThemeApp.availableFonts[index],
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: sheetContext.primary)
                        : null,
                    onTap: () {
                      if (isSelected) {
                        Navigator.of(sheetContext).pop();
                        return;
                      }

                      // 1) شغّل انيميشن الدائرة أولاً
                      ThemeSwitcher.of(parentContext).changeTheme(
                        theme: themeProvider.isDarkMode
                            ? ThemeApp.getDarkTheme(
                                colorIndex: themeProvider.colorIndex,
                                fontIndex: index,
                              )
                            : ThemeApp.getLightTheme(
                                colorIndex: themeProvider.colorIndex,
                                fontIndex: index,
                              ),
                      );

                      // 2) حدّث الـ provider بتأخير بسيط لتجنب الوميض المفاجئ
                      Future.delayed(const Duration(milliseconds: 120), () {
                        themeProvider.changeFont(index);
                      });

                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
