import 'dart:io';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart' hide ThemeProvider;
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/core/theme/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enableNotifications = true;
  bool _floatingVideo = true;
  bool _autoPlayNext = false;
  String _downloadQuality = 'متوسطة';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _enableNotifications = CacheHelper.getBool(key: 'enableNotifications') ?? true;
      _floatingVideo = CacheHelper.getBool(key: 'floatingVideo') ?? true;
      _autoPlayNext = CacheHelper.getBool(key: 'autoPlayNext') ?? false;
      _downloadQuality = CacheHelper.getString(key: 'downloadQuality') ?? 'متوسطة';
    });
  }

  void _saveSetting(String key, dynamic value) {
    CacheHelper.saveData(key: key, value: value);
  }

  Future<void> _clearCache(BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم مسح الذاكرة المؤقتة بنجاح')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء مسح الذاكرة المؤقتة: $e')),
        );
      }
    }
  }

  Future<void> _clearDownloads(BuildContext context) async {
    AppDialog.showDynamicDialog(
      context: context,
      title: 'مسح التنزيلات',
      message: 'هل أنت متأكد أنك تريد مسح جميع الفيديوهات والدروس التي قمت بتنزيلها؟ لا يمكن التراجع عن هذا الإجراء.',
      isError: true,
      confirmText: 'مسح',
      cancelText: 'إلغاء',
      onConfirm: () async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final keys = prefs.getKeys().toList();
          
          for (final key in keys) {
            if (key.startsWith('video_local_path_') || key.startsWith('pdf_local_path_')) {
              final path = prefs.getString(key);
              if (path != null && path.isNotEmpty) {
                final file = File(path);
                if (file.existsSync()) {
                  file.deleteSync();
                }
              }
              await prefs.remove(key);
            }
          }
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم مسح جميع التنزيلات بنجاح')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ أثناء مسح التنزيلات: $e')),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'الإعدادات المتقدمة',
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            _buildSectionHeader(context, ' الإشعارات'),
            _buildSwitchTile(
              context,
              title: 'استقبال الإشعارات',
              subtitle: 'تفعيل إشعارات الدروس والإعلانات الجديدة',
              icon: Icons.notifications_active_rounded,
              iconColor: context.primary,
              value: _enableNotifications,
              onChanged: (val) {
                setState(() => _enableNotifications = val);
                _saveSetting('enableNotifications', val);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, ' العرض والفيديو'),
            _buildSwitchTile(
              context,
              title: 'تشغيل الفيديو كنافذة عائمة',
              subtitle: 'السماح بعرض الفيديو خارج التطبيق (Picture-in-Picture)',
              icon: Icons.picture_in_picture_alt_rounded,
              iconColor: AppColors.amber,
              value: _floatingVideo,
              onChanged: (val) {
                setState(() => _floatingVideo = val);
                _saveSetting('floatingVideo', val);
              },
            ),
            _buildSwitchTile(
              context,
              title: 'التشغيل التلقائي',
              subtitle: 'تشغيل الدرس التالي تلقائياً عند انتهاء الدرس الحالي',
              icon: Icons.auto_mode_rounded,
              iconColor: Colors.blue,
              value: _autoPlayNext,
              onChanged: (val) {
                setState(() => _autoPlayNext = val);
                _saveSetting('autoPlayNext', val);
              },
            ),
            ListTile(
              leading: _buildIcon(context, Icons.high_quality_rounded, Colors.purple),
              title: Text('جودة التحميل الافتراضية', style: context.textTheme.bodyLarge),
              subtitle: Text(_downloadQuality, style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showQualityBottomSheet(context),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'المظهر'),
            ListTile(
              leading: _buildIcon(context, Icons.color_lens_rounded, context.primary),
              title: Text('لون التطبيق الأساسي', style: context.textTheme.bodyLarge),
              subtitle: Text('تغيير لون التطبيق إلى لونك المفضل', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showColorPickerBottomSheet(context),
            ),
            ListTile(
              leading: _buildIcon(context, Icons.font_download_rounded, context.primary),
              title: Text('خط التطبيق', style: context.textTheme.bodyLarge),
              subtitle: Text('تغيير نوع الخط المستخدم في التطبيق', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showFontPickerBottomSheet(context),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'إدارة التخزين'),
            ListTile(
              leading: _buildIcon(context, Icons.cleaning_services_rounded, Colors.teal),
              title: Text('مسح الذاكرة المؤقتة', style: context.textTheme.bodyLarge),
              subtitle: Text('تحرير المساحة من الملفات غير الضرورية', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              onTap: () => _clearCache(context),
            ),
            ListTile(
              leading: _buildIcon(context, Icons.delete_sweep_rounded, Colors.redAccent),
              title: Text('مسح التنزيلات', style: context.textTheme.bodyLarge),
              subtitle: Text('حذف جميع الفيديوهات والدروس المحملة', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              onTap: () => _clearDownloads(context),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'عن المنصة'),
            ListTile(
              leading: _buildIcon(context, Icons.info_outline_rounded, context.primary),
              title: Text('حول المنصة', style: context.textTheme.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                context.push(Routes.aboutPage);
              },
            ),
            ListTile(
              leading: _buildIcon(context, Icons.code_rounded, Colors.purple),
              title: Text('حول المطورون', style: context.textTheme.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                context.push(Routes.developersPage);
              },
            ),
            ListTile(
              leading: _buildIcon(context, Icons.privacy_tip_outlined, Colors.teal),
              title: Text('السياسات والأحكام', style: context.textTheme.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                // TODO: الانتقال إلى صفحة السياسات
              },
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.red.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: _buildIcon(context, Icons.logout_rounded, AppColors.red),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
      secondary: _buildIcon(context, icon, iconColor),
      activeColor: context.primary,
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 24, color: color),
    );
  }

  void _showQualityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اختر جودة التحميل', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildQualityOption('عالية (HD)', context),
                _buildQualityOption('متوسطة', context),
                _buildQualityOption('منخفضة (توفير البيانات)', context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQualityOption(String quality, BuildContext context) {
    return ListTile(
      title: Text(quality),
      trailing: _downloadQuality == quality ? Icon(Icons.check_circle, color: context.primary) : null,
      onTap: () {
        setState(() => _downloadQuality = quality);
        _saveSetting('downloadQuality', quality);
        context.pop();
      },
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
                    Text('اختر لون التطبيق', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                              border: isSelected ? Border.all(color: context.textTheme.bodyLarge?.color ?? Colors.black, width: 3) : null,
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
          }
        );
      },
    );
  }

  void _showFontPickerBottomSheet(BuildContext context) {
    final List<String> fontNames = ['الخط الافتراضي (IBM Plex Sans)', 'خط كايرو (Cairo)', 'خط تجوال (Tajawal)', 'خط المراعي (Almarai)', 'خط تشانجا (Changa)'];
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
                    Text('اختر خط التطبيق', style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
          }
        );
      },
    );
  }
}
