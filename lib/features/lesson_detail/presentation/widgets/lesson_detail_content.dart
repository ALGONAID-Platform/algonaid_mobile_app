import 'package:algonaid_mobail_app/features/lesson_detail/domain/entities/lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/widgets/lesson_video_player.dart';
import 'package:algonaid_mobail_app/features/lesson_detail/presentation/controllers/lesson_detail_download_controller.dart';
import 'package:flutter/material.dart';

class LessonDetailContent extends StatelessWidget {
  final LessonDetail lesson;
  final String? localVideoPath;
  final String? localPdfPath;
  final String? Function(String? pdfUrl) resolvePdfUrl;
  
  final VoidCallback? onVideoStart;
  final VoidCallback? onProgressComplete;
  
  final DownloadStatus pdfDownloadStatus;
  final int pdfDownloadProgress;
  final VoidCallback onPdfDownload;

  const LessonDetailContent({
    super.key,
    required this.lesson,
    required this.localVideoPath,
    required this.localPdfPath,
    required this.resolvePdfUrl,
    this.onVideoStart,
    this.onProgressComplete,
    required this.pdfDownloadStatus,
    required this.pdfDownloadProgress,
    required this.onPdfDownload,
  });

  @override
  Widget build(BuildContext context) {
    final actualExamId = lesson.exam?.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LessonVideoPlayer(
            lessonId: lesson.id,
            videoUrl: lesson.videoUrl,
            localVideoPath: localVideoPath,
            onVideoStart: onVideoStart,
            onProgressComplete: onProgressComplete,
          ),
          const SizedBox(height: 16),
          LessonInfoCard(title: lesson.title),
          const SizedBox(height: 16),
          LessonPdfCard(
            pdfUrl: lesson.pdfUrl,
            downloadStatus: pdfDownloadStatus,
            downloadProgress: pdfDownloadProgress,
            onDownload: onPdfDownload,
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
