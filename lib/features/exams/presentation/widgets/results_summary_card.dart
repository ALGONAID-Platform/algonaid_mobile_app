import 'package:flutter/material.dart';

class ResultsSummaryCard extends StatelessWidget {
  final double scorePercent;
  final bool isSuccess;
  final Color scoreColor;
  final String scoreGrade;

  const ResultsSummaryCard({
    super.key,
    required this.scorePercent,
    required this.isSuccess,
    required this.scoreColor,
    required this.scoreGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scoreColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scoreColor.withOpacity(0.1),
              border: Border.all(color: scoreColor, width: 4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${scorePercent.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  scoreGrade,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isSuccess ? 'ممتاز! لقد نجحت في الاختبار' : 'يجب عليك المحاولة مرة أخرى',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: scoreColor,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSuccess
                ? 'أحسنت! لقد حققت نتيجة جيدة في هذا الاختبار'
                : 'لا تقلق، يمكنك المحاولة مرة أخرى وتحسين نتيجتك',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
