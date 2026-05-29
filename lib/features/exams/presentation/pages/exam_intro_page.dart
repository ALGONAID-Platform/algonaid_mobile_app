import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/widgets/exam_intro_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamIntroPage extends StatefulWidget {
  final String examId;
  final String? previousRoute;

  const ExamIntroPage({super.key, required this.examId, this.previousRoute});

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('تعليمات الاختبار'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          if (examProvider.state == ExamState.loading ||
              examProvider.state == ExamState.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (examProvider.state == ExamState.error ||
              examProvider.exam == null) {
            return AppErrorState(
              message: examProvider.error ?? 'تعذر تحميل بيانات الاختبار.',
              onRetry: () => examProvider.loadExam(int.parse(widget.examId)),
              buttonText: 'إعادة المحاولة',
            );
          }

          final exam = examProvider.exam!;

          return ExamIntroContent(
            title: exam.title,
            totalQuestions: exam.questions.length,
            durationMinutes: 30,
            remainingAttempts: exam.maxAttempts,
            onStartExam: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: examProvider,
                    child: ExamPage(
                      examId: widget.examId,
                      previousRoute: widget.previousRoute,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}
