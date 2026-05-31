import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_snackbar.dart';

class LessonQuizCard extends StatelessWidget {
  final int? examId;
  final String? previousRoute;

  const LessonQuizCard({super.key, this.examId, this.previousRoute});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasExam = examId != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
        border: AppBorder.main_border
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
            child: ElevatedButton.icon(
              onPressed: () {
                if (!hasExam) {
                  debugPrint(
                    'LessonQuizCard: exam page was not opened because examId is null',
                  );
                  AppSnackBar.show(
                    context: context,
                    message: 'الاختبار غير متاح لهذا الدرس حالياً',
                    type: SnackBarType.info,
                  );
                  return;
                }

                final targetRoute = '${Routes.examPage}/$examId';
                debugPrint(
                  'LessonQuizCard: navigating to exam page, examId=$examId, route=$targetRoute',
                );
                GoRouter.of(context).push(targetRoute, extra: previousRoute);
              },
              icon: Icon(hasExam ? Icons.assignment_rounded : Icons.lock_clock_rounded, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasExam
                    ? context.primary
                    : context.colorScheme.onSurface.withOpacity(0.05),
                foregroundColor: hasExam
                    ? Colors.white
                    : context.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text(hasExam ? 'الذهاب للاختبار' : 'سيتوفر قريباً'),
            ),
          ),
        ],
      ),
    );
  }
}
