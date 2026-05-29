import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/pages/exam_page.dart';
import 'package:algonaid_mobail_app/features/exams/presentation/providers/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResultsActionsSection extends StatelessWidget {
  final Exam exam;
  final String? previousRoute;

  const ResultsActionsSection({
    super.key,
    required this.exam,
    this.previousRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final targetRoute = previousRoute ?? Routes.coursesPage;
                GoRouter.of(context).go(targetRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'العودة إلى الرئيسية',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              onPressed: () {
                final navigator = Navigator.of(context);
                final examProvider = getIt<ExamProvider>();
                examProvider.resetExam();
                examProvider.loadExam(exam.id);
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: examProvider,
                      child: ExamPage(
                        examId: exam.id.toString(),
                        previousRoute: previousRoute,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
