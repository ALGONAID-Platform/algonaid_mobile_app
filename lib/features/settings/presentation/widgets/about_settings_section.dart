import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobail_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'عن المنصة'),
        ListTile(
          leading: SettingsIconWrapper(
            icon: Icons.info_outline_rounded,
            color: context.primary,
          ),
          title: Text('حول المنصة', style: context.textTheme.bodyLarge),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push(Routes.aboutPage);
          },
        ),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.code_rounded,
            color: Colors.purple,
          ),
          title: Text('حول المطورون', style: context.textTheme.bodyLarge),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push(Routes.developersPage);
          },
        ),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.privacy_tip_outlined,
            color: Colors.teal,
          ),
          title: Text('السياسات والأحكام', style: context.textTheme.bodyLarge),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push(Routes.policiesPage);
          },
        ),
      ],
    );
  }
}
