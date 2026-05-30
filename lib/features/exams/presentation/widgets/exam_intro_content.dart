import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/info_banner.dart';
import 'package:flutter/material.dart';

class ExamIntroContent extends StatelessWidget {
  final String title;
  final int totalQuestions;
  final int durationMinutes;
  final int remainingAttempts;
  final VoidCallback onStartExam;

  const ExamIntroContent({
    super.key,
    required this.title,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.remainingAttempts,
    required this.onStartExam,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
            border: AppBorder.main_border
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      // const _ExamReadyBadge(),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'يرجى مراجعة تفاصيل الاختبار أدناه قبل البدء. تأكد من استقرار اتصال الإنترنت لديك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ExamIntroInfoRow(
                        icon: Icons.assignment_outlined,
                        label: 'إجمالي الأسئلة',
                        value: '$totalQuestions أسئلة',
                      ),
                      Divider(height: 32, color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round())),
                      ExamIntroInfoRow(
                        icon: Icons.timer_outlined,
                        label: 'الوقت المخصص',
                        value: '$durationMinutes دقيقة',
                      ),
                      Divider(height: 32, color: Theme.of(context).colorScheme.onSurface.withAlpha((0.1 * 255).round())),
                      ExamIntroInfoRow(
                        icon: Icons.refresh_outlined,
                        label: 'المحاولات المتبقية',
                        value: '$remainingAttempts محاولات',
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: onStartExam,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'بدء الاختبار',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const ExamIntroWarningNote(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExamIntroInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ExamIntroInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round())),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExamIntroWarningNote extends StatelessWidget {
  const ExamIntroWarningNote({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = const Color(0xFFF2994A);

    return InfoBanner(
      message: 'المؤقت سيبدأ مباشرة ولا يمكن إيقافه بعد البدء، تأكد من أنك مستعد.',
      icon: Icons.warning_amber_rounded,
      backgroundColor: isDark ? warningColor.withOpacity(0.1) : const Color(0xFFFFF9F2),
      borderColor: isDark ? warningColor.withOpacity(0.2) : const Color(0xFFFFEBD2),
      iconColor: warningColor,
      textStyle: TextStyle(
        fontSize: 12,
        color: warningColor.withOpacity(0.9),
        height: 1.4,
      ),
    );
  }
}

class _ExamReadyBadge extends StatelessWidget {
  const _ExamReadyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'جاهز للبدء؟',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
