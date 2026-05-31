import 'dart:io';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/app_constants.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageSettingsSection extends StatelessWidget {
  const StorageSettingsSection({super.key});

  Future<void> _clearCache(BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
      if (context.mounted) {
        AppSnackBar.show(
          context: context,
          message: 'تم مسح الذاكرة المؤقتة بنجاح',
          type: SnackBarType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.show(
          context: context,
          message: 'حدث خطأ أثناء مسح الذاكرة المؤقتة: $e',
          type: SnackBarType.error,
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
            if (key.startsWith(AppConstants.videoLocalPathPrefix) || key.startsWith(AppConstants.pdfLocalPathPrefix)) {
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
            AppSnackBar.show(
              context: context,
              message: 'تم مسح جميع التنزيلات بنجاح',
              type: SnackBarType.success,
            );
          }
        } catch (e) {
          if (context.mounted) {
            AppSnackBar.show(
              context: context,
              message: 'حدث خطأ أثناء مسح التنزيلات: $e',
              type: SnackBarType.error,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'إدارة التخزين'),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.cleaning_services_rounded,
            color: Colors.teal,
          ),
          title: Text('مسح الذاكرة المؤقتة', style: context.textTheme.bodyLarge),
          subtitle: Text('تحرير المساحة من الملفات غير الضرورية', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          onTap: () => _clearCache(context),
        ),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.delete_sweep_rounded,
            color: Colors.redAccent,
          ),
          title: Text('مسح التنزيلات', style: context.textTheme.bodyLarge),
          subtitle: Text('حذف جميع الفيديوهات والدروس المحملة', style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          onTap: () => _clearDownloads(context),
        ),
      ],
    );
  }
}
