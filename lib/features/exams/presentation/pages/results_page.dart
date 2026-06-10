import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobile_app/features/exams/presentation/widgets/results_actions_section.dart';
import 'package:algonaid_mobile_app/features/exams/presentation/widgets/results_questions_review_section.dart';
import 'package:algonaid_mobile_app/features/exams/presentation/widgets/results_statistics_section.dart';
import 'package:algonaid_mobile_app/features/exams/presentation/widgets/results_summary_card.dart';

class ResultsPage extends StatefulWidget {
  final ExamResult result;
  final Exam exam;
  final String? previousRoute;

  const ResultsPage({
    super.key,
    required this.result,
    required this.exam,
    this.previousRoute,
  });

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
            ResultsSummaryCard(
              scorePercent: scorePercent,
              isSuccess: isSuccess,
              scoreColor: scoreColor,
              scoreGrade: scoreGrade,
            ),
            ResultsStatisticsSection(
              correctAnswers: widget.result.correctAnswers,
              wrongAnswers: widget.exam.questions.length - widget.result.correctAnswers,
              totalQuestions: widget.exam.questions.length,
            ),
            const SizedBox(height: 24),
            ResultsQuestionsReviewSection(
              questions: widget.exam.questions,
              answers: widget.result.answers,
              findUserAnswer: _findUserAnswer,
              findCorrectAnswer: _findCorrectAnswer,
            ),
            const SizedBox(height: 24),
            ResultsActionsSection(
              exam: widget.exam,
              previousRoute: widget.previousRoute,
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
    final correctOptionId = widget.result.correctOptions[question.id];
    final isUserCorrect = userAnswerId != null && userAnswerId == correctOptionId;

    if (userAnswerId == null) {
      return Option(
        id: -1,
        text: 'لم يتم اختيار إجابة',
        isCorrect: false,
        questionId: question.id,
      );
    }

    for (final option in question.options) {
      if (option.id == userAnswerId) {
        return Option(
          id: option.id,
          text: option.text,
          isCorrect: isUserCorrect,
          questionId: option.questionId,
        );
      }
    }

    return Option(
      id: -1,
      text: 'لم يتم العثور على الإجابة',
      isCorrect: false,
      questionId: question.id,
    );
  }

  Option _findCorrectAnswer(Question question) {
    final correctOptionId = widget.result.correctOptions[question.id];

    for (final option in question.options) {
      if (option.id == correctOptionId) {
        return Option(
          id: option.id,
          text: option.text,
          isCorrect: true,
          questionId: option.questionId,
        );
      }
    }

    // Fallback if not found in correctOptions map
    for (final option in question.options) {
      if (option.isCorrect) {
        return option;
      }
    }

    return const Option(
      id: -1,
      text: 'لا توجد إجابة صحيحة محددة',
      isCorrect: false,
      questionId: -1,
    );
  }
}
