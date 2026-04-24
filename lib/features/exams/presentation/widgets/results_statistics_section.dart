import 'package:flutter/material.dart';

class ResultsStatisticsSection extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  const ResultsStatisticsSection({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatisticCard(
              icon: Icons.check_circle,
              label: 'الإجابات الصحيحة',
              value: correctAnswers.toString(),
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatisticCard(
              icon: Icons.cancel,
              label: 'الإجابات الخاطئة',
              value: wrongAnswers.toString(),
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatisticCard(
              icon: Icons.quiz,
              label: 'إجمالي الأسئلة',
              value: totalQuestions.toString(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
