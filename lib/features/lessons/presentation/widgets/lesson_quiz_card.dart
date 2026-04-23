import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';

class LessonQuizCard extends StatelessWidget {
  final int? examId;

  const LessonQuizCard({super.key, this.examId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختبار الدرس',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اختبر فهمك لهذا الدرس',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
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

