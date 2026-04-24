import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';

class LessonQuizCard extends StatelessWidget {
  final int? examId;

  const LessonQuizCard({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.primary.withOpacity(0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختبار الدرس',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اختبر فهمك لهذا الدرس',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (examId == null) {
                  debugPrint(
                    'LessonQuizCard: exam page was not opened because examId is null',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الاختبار غير متاح لهذا الدرس حالياً'),
                    ),
                  );
                  return;
                }

                final targetRoute = '${Routes.examPage}/$examId';
                debugPrint(
                  'LessonQuizCard: navigating to exam page, examId=$examId, route=$targetRoute',
                );
                context.push(targetRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(examId != null ? 'الذهاب للاختبار' : 'سيتوفر قريباً'),
            ),
          ),
        ],
      ),
    );
  }
}
