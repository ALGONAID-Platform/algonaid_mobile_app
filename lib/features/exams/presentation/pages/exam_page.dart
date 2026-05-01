import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_error_state.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_intro_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/widgets/exam_widget.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/results_page.dart';

class ExamPage extends StatefulWidget {
  final String examId;
  final String? previousRoute;

  const ExamPage({super.key, required this.examId, this.previousRoute});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('ExamPage: initState for examId=${widget.examId}');
    Future.microtask(() {
      if (mounted) {
        final examProvider = context.read<ExamProvider>();
        debugPrint(
          'ExamPage: entry check for examId=${widget.examId}, '
          'providerState=${examProvider.state}, loadedExamId=${examProvider.exam?.id}',
        );
        final mustOpenIntroFirst =
            examProvider.exam?.id.toString() != widget.examId ||
            examProvider.state == ExamState.initial ||
            (!examProvider.isSubmitted && examProvider.attemptId == null);

        if (mustOpenIntroFirst) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: examProvider,
                child: ExamIntroPage(
                  examId: widget.examId,
                  previousRoute: widget.previousRoute,
                ),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ExamProvider>(
          builder: (context, examProvider, child) {
            if (examProvider.exam != null) {
              return Text(examProvider.exam!.title);
            }
            return const Text('Exam');
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          debugPrint(
            'ExamPage: build for examId=${widget.examId}, state=${examProvider.state}, '
            'loadedExamId=${examProvider.exam?.id}, questions=${examProvider.totalQuestions}, '
            'attemptId=${examProvider.attemptId}, error=${examProvider.error}',
          );
          // 1. Show loading state
          if (examProvider.state == ExamState.loading ||
              examProvider.state == ExamState.initial) {
            return const SizedBox.shrink();
          }

          // 2. Show error state
          if (examProvider.state == ExamState.error) {
            debugPrint(
              'ExamPage: showing error state for examId=${widget.examId}, '
              'message=${examProvider.error}',
            );
            return AppErrorState(
              message: examProvider.error ?? 'حدث خطأ غير متوقع',
              onRetry: () => examProvider.loadExam(int.parse(widget.examId)),
              buttonText: 'تحميل الاختبار مرة أخرى',
            );
          }

          // 3. Show results if exam is submitted
          if (examProvider.isSubmitted && examProvider.result != null) {
            return ResultsPage(
              result: examProvider.result!,
              exam: examProvider.exam!,
              previousRoute: widget.previousRoute,
            );
          }

          // 4. Show exam content (ensure exam and currentQuestion are not null)
          final exam = examProvider.exam;
          final currentQuestion = examProvider.currentQuestion;

          if (exam != null && currentQuestion != null) {
            final answeredList = List.generate(
              examProvider.totalQuestions,
              (index) => examProvider.answers.containsKey(
                examProvider.questionAt(index)?.id,
              ),
            );

            return SingleChildScrollView(
              child: Column(
                children: [
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
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Question navigation
                        QuestionNavigation(
                          totalQuestions: examProvider.totalQuestions,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'تأكد من مراجعة خطوات الحل بدقة قبل اختيار الإجابة. يمكنك تعديل إجاباتك في أي وقت.',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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

          // Fallback if data is missing despite being in loaded state
          debugPrint(
            'ExamPage: loaded state but no renderable data for examId=${widget.examId}, '
            'exam=${examProvider.exam != null}, currentQuestion=${examProvider.currentQuestion != null}',
          );
          return AppErrorState(
            message: 'لا توجد أسئلة متاحة لهذا الاختبار حالياً.',
            onRetry: () => examProvider.loadExam(int.parse(widget.examId)),
            buttonText: 'إعادة المحاولة',
          );
        },
      ),
      bottomNavigationBar: Consumer<ExamProvider>(
        builder: (context, examProvider, _) {
          if (examProvider.exam == null ||
              examProvider.currentQuestion == null ||
              examProvider.isSubmitted) {
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
              if (examProvider.answeredQuestions !=
                  examProvider.totalQuestions) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'الرجاء الإجابة على جميع الأسئلة قبل التسليم.',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if ((examProvider.attemptId ?? 0) <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'لا يمكن تسليم الاختبار بدون اتصال بالإنترنت. يمكنك المتابعة والمراجعة ثم الإرسال عند عودة الاتصال.',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
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
