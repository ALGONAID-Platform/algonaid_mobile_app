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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF26B5B5),
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
                      const _ExamReadyBadge(),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'يرجى مراجعة تفاصيل الاختبار أدناه قبل البدء. تأكد من استقرار اتصال الإنترنت لديك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9094A6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ExamIntroInfoRow(
                        icon: Icons.assignment_outlined,
                        label: 'إجمالي الأسئلة',
                        value: '$totalQuestions أسئلة',
                      ),
                      const Divider(height: 32, color: Color(0xFFF1F2F6)),
                      ExamIntroInfoRow(
                        icon: Icons.timer_outlined,
                        label: 'الوقت المخصص',
                        value: '$durationMinutes دقيقة',
                      ),
                      const Divider(height: 32, color: Color(0xFFF1F2F6)),
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
                            backgroundColor: const Color(0xFF26B5B5),
                            foregroundColor: Colors.white,
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
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF26B5B5), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9094A6)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEBD2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF2994A),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'المؤقت سيبدأ مباشرة ولا يمكن إيقافه بعد البدء، تأكد من أنك مستعد.',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFF2994A).withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
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
        color: const Color(0xFFE9F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'جاهز للبدء؟',
        style: TextStyle(
          color: Color(0xFF26B5B5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
