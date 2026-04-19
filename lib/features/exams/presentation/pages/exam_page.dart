import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/widgets/exam_widget.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/results_page.dart';

class ExamPage extends StatefulWidget {
  final String examId;

  ExamPage({Key? key, required this.examId}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  void initState() {
    super.initState();
    // Load exam data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().loadExam(widget.examId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          // Show loading state
          if (examProvider.state == ExamState.loading) {
            return const Center(
              child: CircularProgressIndicator(), // Removed hardcoded color
            );
          }

          // Show error state
          if (examProvider.state == ExamState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red), // Red for error is fine
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ: ${examProvider.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground), // Theme aware text color
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => examProvider.loadExam(widget.examId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      'إعادة المحاولة',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            );
          }

          // Show results if exam is submitted
          if (examProvider.isSubmitted && examProvider.result != null) {
            return ResultsPage(
              result: examProvider.result!,
              exam: examProvider.exam!,
            );
          }

          // Show exam content
          if (examProvider.exam != null &&
              examProvider.currentQuestion != null) {
            final exam = examProvider.exam!;
            final currentQuestion = examProvider.currentQuestion!;
            final answeredList = List.generate(
              exam.totalQuestions,
              (index) =>
                  examProvider.answers.containsKey(exam.questions[index].id),
            );

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  ExamHeader(
                    studentName: exam.studentName,
                    studentImage: exam.studentImage,
                    subject: exam.subject,
                    remainingMinutes: exam.duration,
                    totalQuestions: exam.totalQuestions,
                    currentQuestion: examProvider.currentQuestionIndex + 1,
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Question card
                        QuestionCard(
                          question: currentQuestion,
                          onImageTap: () {
                            // Handle image tap (e.g., show full screen image)
                          },
                        ),
                        const SizedBox(height: 24),
                        // Answer options
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'الخيارات المتاحة:',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...currentQuestion.options.map((option) {
                              final isSelected =
                                  examProvider
                                      .getUserAnswerForCurrentQuestion() ==
                                  option.id;
                              return AnswerOption(
                                option: option,
                                isSelected: isSelected,
                                onTap: () {
                                  examProvider.selectAnswer(option.id);
                                },
                              );
                            }).toList(),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Question navigation
                        QuestionNavigation(
                          totalQuestions: exam.totalQuestions,
                          currentQuestion: examProvider.currentQuestionIndex,
                          answeredQuestions: answeredList,
                          onQuestionSelected: (index) {
                            examProvider.goToQuestion(index);
                          },
                        ),
                        const SizedBox(height: 24),
                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Theme.of(context).colorScheme.primary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'تأكد من مراجعة خطوات الحل بدقة قبل اختيار الإجابة. يمكنك تعديل إجاباتك في أي وقت.',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.primary,
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          if (examProvider.exam == null || examProvider.isSubmitted) {
            return const SizedBox.shrink();
          }

          final isFirstQuestion = examProvider.currentQuestionIndex == 0;
          final isLastQuestion =
              examProvider.currentQuestionIndex ==
              examProvider.totalQuestions - 1;

          return ExamBottomNavigation(
            showPrevious: !isFirstQuestion,
            showNext: !isLastQuestion,
            showSubmit: isLastQuestion,
            onPrevious: () {
              examProvider.previousQuestion();
            },
            onNext: () {
              examProvider.nextQuestion();
            },
            onSubmit: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تسليم الاختبار'),
                  content: Text(
                    'هل أنت متأكد من تسليم الاختبار؟\nعدد الإجابات: ${examProvider.answeredQuestions}/${examProvider.totalQuestions}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        examProvider.submitExam();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        'تسليم',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
