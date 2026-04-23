import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonQuizCard extends StatelessWidget {
  const LessonQuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),

      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختبار الدرس',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اختبر فهمك لهذا الدرس قريبًا',
            style: context.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.surfaceContainer,
                foregroundColor: context.onBackground,
                disabledBackgroundColor: context.surfaceContainer,
                disabledForegroundColor: context.onBackground,
              ),
              child: const Text('سيتوفر قريبًا'),
            ),
          ),
        ],
      ),
    );
  }
}
