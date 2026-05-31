import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/features/settings/data/datasources/settings_static_datasource.dart';
import 'package:algonaid_mobail_app/features/settings/domain/entities/policy_item.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/shared_app_bar.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const dataSource = SettingsStaticDataSourceImpl();
    final policies = dataSource.getPolicies();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const SharedAppBar(
          title: 'السياسات والأحكام',
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ...policies.map((policy) {
              return _buildSection(
                context,
                title: policy.title,
                content: policy.content,
              );
            }).toList(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.gavel_rounded, size: 32, color: context.primary),
                  const SizedBox(height: 12),
                  Text(
                    'تمثل هذه الوثيقة اتفاقية قانونية ملزمة بين المستخدم ومنصة Algonaid. إذا كانت لديك أي استفسارات، يرجى التواصل مع الدعم الفني.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: context.onBackground.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: context.onBackground.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
