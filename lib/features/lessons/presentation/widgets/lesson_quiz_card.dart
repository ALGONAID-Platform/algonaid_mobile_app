import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
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
    final hasExam = examId != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
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
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasExam ? 'اختبر فهمك لهذا الدرس' : 'اختبر فهمك لهذا الدرس قريبًا',
            style: context.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!hasExam) {
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
                GoRouter.of(context).push(targetRoute);
              },
              style: ElevatedButton.styleFrom(
                // دمج الألوان بناءً على حالة توفر الاختبار
                backgroundColor: hasExam ? theme.colorScheme.primary : context.surfaceContainer,
                foregroundColor: hasExam ? theme.colorScheme.onPrimary : context.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(hasExam ? 'الذهاب للاختبار' : 'سيتوفر قريباً'),
            ),
          ),
        ],
      ),
    );
  }
}