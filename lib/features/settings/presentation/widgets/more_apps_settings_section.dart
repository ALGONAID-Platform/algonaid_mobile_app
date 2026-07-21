import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreAppsSettingsSection extends StatelessWidget {
  const MoreAppsSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'المزيد من التطبيقات'),
        const SizedBox(height: 8),
        // App item
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.application.karti');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
                color: context.background,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/karti_app.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تطبيق كرتي',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'رصيد للألعاب، اشتراكاتك، وإنترنتك، كله بمكان واحد! يمكنك شراء بطاقات الشحن وتجديد اشتراكاتك بكل سهولة ويسر. قم بتحميله الآن!',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onBackground
                                .withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
