import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/material.dart';

class LessonDetailContent extends StatelessWidget {
  final LessonDetail lesson;
  final String? localVideoPath;
  final String? localPdfPath;
  final String? Function(String? pdfUrl) resolvePdfUrl;

  const LessonDetailContent({
    super.key,
    required this.lesson,
    required this.localVideoPath,
    required this.localPdfPath,
    required this.resolvePdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    final actualExamId = lesson.exam?.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LessonVideoPlayer(
            videoUrl: lesson.videoUrl,
            localVideoPath: localVideoPath,
          ),
          const SizedBox(height: 16),
          LessonInfoCard(title: lesson.title),
          const SizedBox(height: 16),
          LessonPdfCard(
            pdfUrl: lesson.pdfUrl,
            onOpen: () {
              final pdfUrl = localPdfPath ?? resolvePdfUrl(lesson.pdfUrl);
              if (pdfUrl == null) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonPdfViewerPage(
                    pdfUrl: pdfUrl,
                    title: lesson.title,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          LessonTabs(
            description: lesson.description,
            content: lesson.content,
          ),
          const SizedBox(height: 16),
          LessonQuizCard(examId: actualExamId),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
