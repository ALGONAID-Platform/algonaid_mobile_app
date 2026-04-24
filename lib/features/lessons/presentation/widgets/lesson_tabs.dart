import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonTabs extends StatelessWidget {
  final String? description;
  final String? content;

  const LessonTabs({super.key, this.description, this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.primary.withOpacity(0.10),
          ),
          boxShadow: isDark
              ? const []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(
                0.68,
              ),
              indicatorColor: AppColors.primary,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.78),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'سيتم إضافة قسم التعليقات قريبًا.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.78),
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
