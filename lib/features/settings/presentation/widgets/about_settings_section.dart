import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_icon_wrapper.dart';
import 'package:algonaid_mobile_app/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/967772971739");
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          AppSnackBar.show(
            context: context,
            message: 'تعذر فتح تطبيق واتساب. يرجى التأكد من تثبيته.',
            type: SnackBarType.error,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.show(
          context: context,
          message: 'حدث خطأ أثناء محاولة فتح واتساب: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'عن المنصة'),
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.code_rounded,
            color: Colors.purple,
          ),
          title: Text('حول المطورين', style: context.textTheme.bodyLarge),
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
        ListTile(
          leading: const SettingsIconWrapper(
            icon: Icons.support_agent_rounded,
            color: Colors.green,
          ),
          title: Text('التواصل والدعم (واتساب)', style: context.textTheme.bodyLarge),
          subtitle: Text(
            'لأي استفسارات أو الإبلاغ عن مشكلة',
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () => _launchWhatsApp(context),
        ),
      ],
    );
  }
}

