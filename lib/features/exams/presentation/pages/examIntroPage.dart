import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamIntroPage extends StatefulWidget {
  final String examId;

  const ExamIntroPage({super.key, required this.examId});

  @override
  State<ExamIntroPage> createState() => _ExamIntroPageState();
}

class _ExamIntroPageState extends State<ExamIntroPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) {
        return;
      }

      final examProvider = context.read<ExamProvider>();
      if (examProvider.exam?.id.toString() != widget.examId ||
          examProvider.state == ExamState.initial) {
        examProvider.loadExam(int.parse(widget.examId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('تعليمات الاختبار'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          if (examProvider.state == ExamState.loading ||
              examProvider.state == ExamState.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (examProvider.state == ExamState.error || examProvider.exam == null) {
            return AppErrorState(
              message: examProvider.error ?? 'تعذر تحميل بيانات الاختبار.',
              onRetry: () => examProvider.loadExam(int.parse(widget.examId)),
              buttonText: 'إعادة المحاولة',
            );
          }

          final exam = examProvider.exam!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ExamInstructionsWidget(
                title: exam.title,
                totalQuestions: exam.questions.length,
                remainingAttempts: exam.maxAttempts,
                onStartExam: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: examProvider,
                        child: ExamPage(examId: widget.examId),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExamInstructionsWidget extends StatelessWidget {
  final String title;
  final int totalQuestions;
  final int durationMinutes;
  final int remainingAttempts;
  final VoidCallback onStartExam;

  const ExamInstructionsWidget({
    super.key,
    this.title = 'اختبار الدروس',
    this.totalQuestions = 6,
    this.durationMinutes = 30,
    this.remainingAttempts = 3,
    required this.onStartExam,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
            // Top Green Bar
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                children: [
                  // "جاهز للبدء؟" badge
                  Container(
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
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Main Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Subtitle
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
                  
                  // Info Rows
                  _buildInfoRow(
                    icon: Icons.assignment_outlined,
                    label: 'إجمالي الأسئلة',
                    value: '$totalQuestions أسئلة',
                  ),
                  const Divider(height: 32, color: Color(0xFFF1F2F6)),
                  _buildInfoRow(
                    icon: Icons.timer_outlined,
                    label: 'الوقت المخصص',
                    value: '$durationMinutes دقيقة',
                  ),
                  const Divider(height: 32, color: Color(0xFFF1F2F6)),
                  _buildInfoRow(
                    icon: Icons.refresh_outlined,
                    label: 'المحاولات المتبقية',
                    value: '$remainingAttempts محاولات',
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Start Button
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
                  
                  // Warning Note
                  Container(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF26B5B5),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9094A6),
                ),
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
