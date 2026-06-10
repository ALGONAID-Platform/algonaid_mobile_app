import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/theme.dart';
import 'package:algonaid_mobile_app/core/theme/theme_provider.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_section_title.dart';
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
                style: themeContext.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                final switcher = ThemeSwitcher.of(themeContext);
                _showColorPickerBottomSheet(themeContext, switcher);
              },
            ),
            ListTile(
              leading: SettingsIconWrapper(
                icon: Icons.font_download_rounded,
                color: themeContext.primary,
              ),
              title: Text('خط التطبيق', style: themeContext.textTheme.bodyLarge),
              subtitle: Text(
                'تغيير نوع الخط المستخدم في التطبيق',
                style: themeContext.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                final switcher = ThemeSwitcher.of(themeContext);
                _showFontPickerBottomSheet(themeContext, switcher);
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerBottomSheet(BuildContext parentContext, ThemeSwitcherState switcher) {
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
                      style: sheetContext.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(ThemeApp.availableColors.length, (
                        index,
                      ) {
                        final color = ThemeApp.availableColors[index];
                        final isSelected = tempSelectedColorIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedColorIndex = index;
                            });
                          },
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
                      }),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(sheetContext).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                              // Update our custom provider (persists the change)
                              themeProvider.changeColor(tempSelectedColorIndex);

                              // Trigger animated theme switch on the root theme switcher using parentContext
                              switcher.changeTheme(
                                theme: themeProvider.isDarkMode
                                    ? ThemeApp.getDarkTheme(
                                        colorIndex: tempSelectedColorIndex,
                                        fontIndex: themeProvider.fontIndex,
                                      )
                                    : ThemeApp.getLightTheme(
                                        colorIndex: tempSelectedColorIndex,
                                        fontIndex: themeProvider.fontIndex,
                                      ),
                              );

                              // Close the bottom sheet
                              Navigator.of(sheetContext).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeApp
                                  .availableColors[tempSelectedColorIndex],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
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

  void _showFontPickerBottomSheet(BuildContext parentContext, ThemeSwitcherState switcher) {
    final List<String> fontNames = [
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
                  style: sheetContext.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(ThemeApp.availableFonts.length, (index) {
                  return ListTile(
                    title: Text(
                      fontNames[index],
                      style: TextStyle(
                        fontFamily: ThemeApp.availableFonts[index],
                      ),
                    ),
                    trailing: themeProvider.fontIndex == index
                        ? Icon(Icons.check_circle, color: sheetContext.primary)
                        : null,
                    onTap: () {
                      // Update our custom provider (persists the change)
                      themeProvider.changeFont(index);

                      // Trigger animated theme switch on the root theme switcher using parentContext
                      switcher.changeTheme(
                        theme: themeProvider.isDarkMode
                            ? ThemeApp.getDarkTheme(colorIndex: themeProvider.colorIndex, fontIndex: index)
                            : ThemeApp.getLightTheme(colorIndex: themeProvider.colorIndex, fontIndex: index),
                      );

                      // Close the bottom sheet
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
