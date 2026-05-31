import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';

class VideoSettingsSection extends StatelessWidget {
  final bool floatingVideo;
  final ValueChanged<bool> onFloatingVideoChanged;
  final bool autoPlayNext;
  final ValueChanged<bool> onAutoPlayNextChanged;
  final String downloadQuality;
  final VoidCallback onSelectDownloadQuality;

  const VideoSettingsSection({
    super.key,
    required this.floatingVideo,
    required this.onFloatingVideoChanged,
    required this.autoPlayNext,
    required this.onAutoPlayNextChanged,
    required this.downloadQuality,
    required this.onSelectDownloadQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: ' العرض والفيديو'),
        SwitchListTile(
          value: floatingVideo,
          onChanged: onFloatingVideoChanged,
          title: Text(
            'تشغيل الفيديو كنافذة عائمة',
            style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'السماح بعرض الفيديو خارج التطبيق (Picture-in-Picture)',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          secondary: const SettingsIconWrapper(
            icon: Icons.picture_in_picture_alt_rounded,
            color: AppColors.amber,
          ),
          activeColor: context.primary,
        ),
        SwitchListTile(
          value: autoPlayNext,
          onChanged: onAutoPlayNextChanged,
          title: Text(
            'التشغيل التلقائي',
            style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'تشغيل الدرس التالي تلقائياً عند انتهاء الدرس الحالي',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          secondary: const SettingsIconWrapper(
            icon: Icons.auto_mode_rounded,
            color: Colors.blue,
          ),
          activeColor: context.primary,
        ),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.high_quality_rounded,
            color: Colors.purple,
          ),
          title: Text(
            'جودة التحميل الافتراضية',
            style: context.textTheme.bodyLarge,
          ),
          subtitle: Text(
            downloadQuality,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: onSelectDownloadQuality,
        ),
      ],
    );
  }
}
