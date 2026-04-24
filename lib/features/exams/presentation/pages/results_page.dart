import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:get_it/get_it.dart';

class ResultsPage extends StatefulWidget {
  final ExamResult result;
  final Exam exam;

  const ResultsPage({Key? key, required this.result, required this.exam})
    : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    final scorePercent = _scorePercent();
    final isSuccess = scorePercent >= widget.exam.passingScore;
    final scoreColor = isSuccess ? Colors.green : Colors.red;
    final scoreGrade = _getScoreGrade(scorePercent);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score summary card
            Container(
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
                  // Score circle
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
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        Text(
                          scoreGrade,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Result message
                  Text(
                    isSuccess
                        ? 'ممتاز! لقد نجحت في الاختبار'
                        : 'يجب عليك المحاولة مرة أخرى',
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
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Statistics cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatisticCard(
                      icon: Icons.check_circle,
                      label: 'الإجابات الصحيحة',
                      value: widget.result.correctAnswers.toString(),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatisticCard(
                      icon: Icons.cancel,
                      label: 'الإجابات الخاطئة',
                      value: widget.result.wrongAnswers.toString(),
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatisticCard(
                      icon: Icons.quiz,
                      label: 'إجمالي الأسئلة',
                      value: widget.result.totalQuestions.toString(),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary, // Theme aware
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Questions review section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مراجعة الأسئلة',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(widget.exam.questions.length, (index) {
                    final question = widget.exam.questions[index];
                    final userAnswerId = widget.result.answers[question.id];
                    final userAnswer = _findUserAnswer(
                      question: question,
                      userAnswerId: userAnswerId,
                    );
                    final correctAnswer = _findCorrectAnswer(question);
                    final isCorrect = userAnswer.isCorrect;

                    return Column(
                      children: [
                        _QuestionReviewCard(
                          questionNumber: index + 1,
                          question: question,
                          userAnswer: userAnswer,
                          correctAnswer: correctAnswer,
                          isCorrect: isCorrect,
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'العودة إلى الرئيسية',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () async {
                        // Retake exam
                        final examProvider = getIt<ExamProvider>();
                        examProvider.resetExam();
                        await examProvider.loadExam(widget.exam.id);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: examProvider,
                              child: ExamPage(
                                examId: widget.exam.id.toString(),
                              ),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'اعادة الاختبار',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getScoreGrade(double score) {
    if (score >= 90) return 'ممتاز جداً';
    if (score >= 80) return 'ممتاز';
    if (score >= 70) return 'جيد جداً';
    if (score >= 60) return 'جيد';
    return 'ضعيف';
  }

  double _scorePercent() {
    final totalPoints = widget.exam.questions.fold<int>(
      0,
      (sum, question) => sum + question.points,
    );
    if (totalPoints == 0) {
      return 0;
    }
    return (widget.result.score / totalPoints) * 100;
  }

  Option _findUserAnswer({
    required Question question,
    required int? userAnswerId,
  }) {
    if (userAnswerId == null) {
      return const Option(
        id: -1,
        text: 'No Answer Selected',
        isCorrect: false,
        questionId: -1,
      );
    }

    for (final option in question.options) {
      if (option.id == userAnswerId) {
        return option;
      }
    }

    return const Option(
      id: -1,
      text: 'No Answer Selected',
      isCorrect: false,
      questionId: -1,
    );
  }

  Option _findCorrectAnswer(Question question) {
    for (final option in question.options) {
      if (option.isCorrect) {
        return option;
      }
    }

    return const Option(
      id: -1,
      text: 'No Correct Answer',
      isCorrect: false,
      questionId: -1,
    );
  }
}

/// Statistic card widget
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
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Question review card widget
class _QuestionReviewCard extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final Option userAnswer;
  final Option correctAnswer;
  final bool isCorrect;

  const _QuestionReviewCard({
    required this.questionNumber,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  @override
  State<_QuestionReviewCard> createState() => _QuestionReviewCardState();
}

class _QuestionReviewCardState extends State<_QuestionReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isCorrect ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: borderColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      widget.isCorrect ? Icons.check : Icons.close,
                      color: borderColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Question info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السؤال ${widget.questionNumber}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: borderColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Expand icon
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(
                      context,
                    ).iconTheme.color?.withOpacity(0.6), // Theme aware
                  ),
                ],
              ),
            ),
          ),
          // Expanded content
          if (_expanded) ...[
            Divider(height: 1, color: Theme.of(context).dividerColor),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Question text
                  Text(
                    widget.question.text,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User answer
                  _AnswerBox(
                    label: 'إجابتك',
                    answer: widget.userAnswer.text,
                    isCorrect: widget.isCorrect,
                    color: widget.isCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 12),
                  // Correct answer (if wrong)
                  if (!widget.isCorrect)
                    _AnswerBox(
                      label: 'الإجابة الصحيحة',
                      answer: widget.correctAnswer.text,
                      isCorrect: true,
                      color: Colors.green,
                    ),
                  const SizedBox(height: 12),
                  // Explanation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الشرح',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.question.explanation ?? 'لا يوجد شرح متاح',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.8),
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Answer box widget
class _AnswerBox extends StatelessWidget {
  final String label;
  final String answer;
  final bool isCorrect;
  final Color color;

  const _AnswerBox({
    required this.label,
    required this.answer,
    required this.isCorrect,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
