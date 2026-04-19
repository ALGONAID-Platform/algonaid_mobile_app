import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // New Import
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart'; // New Import

class LessonQuizCard extends StatelessWidget {
  final String? examId; // New Field
  const LessonQuizCard({super.key, this.examId}); // Modified constructor

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
            // Update text based on exam availability
            examId != null ? 'اختبر فهمك لهذا الدرس' : 'سيتوفر الاختبار قريباً',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  examId !=
                      null // Enable/disable based on examId
                  ? () {
                      debugPrint('Navigating to Exam Page for exam: $examId');
                      GoRouter.of(context).push('${Routes.examPage}/$examId');
                    }
                  : null, // If examId is null, button is disabled
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              child: Text(examId != null ? 'الذهاب للاختبار' : 'سيتوفر قريباً'),
            ),
          ),
        ],
      ),
    );
  }
}
