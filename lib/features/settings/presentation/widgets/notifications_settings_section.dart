import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsSection extends StatelessWidget {
  final bool enableNotifications;
  final ValueChanged<bool> onNotificationsChanged;

  const NotificationsSettingsSection({
    super.key,
    required this.enableNotifications,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: ' الإشعارات'),
        SwitchListTile(
          value: enableNotifications,
          onChanged: onNotificationsChanged,
          title: Text(
            'استقبال الإشعارات',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'تفعيل إشعارات الدروس والإعلانات الجديدة',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          secondary: SettingsIconWrapper(
            icon: Icons.notifications_active_rounded,
            color: context.primary,
          ),
          activeColor: context.primary,
        ),
      ],
    );
  }
}
