import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/features/search/domain/entities/global_search_entity.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid_mobile_app/features/lesson_detail/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:flutter/material.dart';

class SearchPracticeExamsTab extends StatelessWidget {
  final List<SearchPracticeExamEntity> practiceExams;

  const SearchPracticeExamsTab({
    super.key,
    required this.practiceExams,
  });

  @override
  Widget build(BuildContext context) {
    if (practiceExams.isEmpty) {
      return const AppEmptyState(
        icon: Icons.search_off_rounded,
        title: 'لا توجد نتائج',
        subtitle: 'لا توجد نماذج اختبارات مطابقة',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: practiceExams.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final exam = practiceExams[index];
        final subtitle = exam.courseTitle ?? exam.grade;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.picture_as_pdf, color: context.primary),
          ),
          title: Text(
            exam.title,
            style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.7),
                  ),
                )
              : null,
          trailing: Icon(
            Icons.open_in_new,
            size: 16,
            color: context.colorScheme.onSurface.withOpacity(0.5),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LessonPdfViewerPage(
                  pdfUrl: exam.pdfUrl,
                  title: exam.title,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
