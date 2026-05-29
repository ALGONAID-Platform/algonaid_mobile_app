import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:flutter/material.dart';

class ResultsQuestionsReviewSection extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int> answers;
  final Option Function({
    required Question question,
    required int? userAnswerId,
  })
  findUserAnswer;
  final Option Function(Question question) findCorrectAnswer;

  const ResultsQuestionsReviewSection({
    super.key,
    required this.questions,
    required this.answers,
    required this.findUserAnswer,
    required this.findCorrectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          ...List.generate(questions.length, (index) {
            final question = questions[index];
            final userAnswerId = answers[question.id];
            final userAnswer = findUserAnswer(
              question: question,
              userAnswerId: userAnswerId,
            );
            final correctAnswer = findCorrectAnswer(question);

            return Column(
              children: [
                QuestionReviewCard(
                  questionNumber: index + 1,
                  question: question,
                  userAnswer: userAnswer,
                  correctAnswer: correctAnswer,
                  isCorrect: userAnswer.isCorrect,
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class QuestionReviewCard extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final Option userAnswer;
  final Option correctAnswer;
  final bool isCorrect;

  const QuestionReviewCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  @override
  State<QuestionReviewCard> createState() => _QuestionReviewCardState();
}

class _QuestionReviewCardState extends State<QuestionReviewCard> {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السؤال ${widget.questionNumber}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: borderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: Theme.of(context).dividerColor),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  _AnswerBox(
                    label: 'إجابتك',
                    answer: widget.userAnswer.text,
                    color: widget.isCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 12),
                  if (!widget.isCorrect)
                    _AnswerBox(
                      label: 'الإجابة الصحيحة',
                      answer: widget.correctAnswer.text,
                      color: Colors.green,
                    ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(
                        0.05,
                      ),
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.question.explanation ?? 'لا يوجد شرح متاح',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class _AnswerBox extends StatelessWidget {
  final String label;
  final String answer;
  final Color color;

  const _AnswerBox({
    required this.label,
    required this.answer,
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
