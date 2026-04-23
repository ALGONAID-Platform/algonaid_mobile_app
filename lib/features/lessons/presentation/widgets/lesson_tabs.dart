import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonTabs extends StatelessWidget {
  final String? description;
  final String? content;

  const LessonTabs({super.key, this.description, this.content});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: context.primary,
              unselectedLabelColor: AppColors.textSecondaryLight,
              indicatorColor: context.primary,
              tabs: const [
                Tab(text: 'الوصف'),
                Tab(text: 'التعليقات'),
              ],
            ),
            SizedBox(
              height: 180,
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      description?.isNotEmpty == true
                          ? description!
                          : (content?.isNotEmpty == true
                                ? content!
                                : 'لا يوجد وصف متوفر لهذا الدرس حالياً.'),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'سيتم إضافة قسم التعليقات قريبًا.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
