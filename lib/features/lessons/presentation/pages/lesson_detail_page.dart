import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/providers/lesson_detail_provider.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonDetailPage extends StatelessWidget {
  final int lessonId;

  const LessonDetailPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    // We already provide LessonDetailProvider higher up in the widget tree.
    // Ensure the lesson is loaded when this page is accessed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonDetailProvider>().loadLesson(lessonId);
    });
    return const _LessonDetailView();
  }
}

class _LessonDetailView extends StatelessWidget {
  const _LessonDetailView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: AppBar(
          title: const Text('تفاصيل الدرس'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            label: const Text('قائمة الدروس'),
            icon: const Icon(Icons.list_alt),
          ),
        ),
        body: Consumer<LessonDetailProvider>(
          builder: (context, provider, _) {
            final state = provider.state;
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final lesson = state.lesson;
            if (lesson == null) {
              return const Center(child: Text('تعذر تحميل الدرس'));
            }

            final pdfUrl = _resolvePdfUrl(lesson.pdfUrl);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LessonVideoPlayer(videoUrl: lesson.videoUrl),
                  const SizedBox(height: 16),
                  LessonInfoCard(title: lesson.title),
                  const SizedBox(height: 16),
                  LessonTabs(
                    description: lesson.description,
                    content: lesson.content,
                  ),
                  const SizedBox(height: 16),
                  LessonPdfCard(
                    pdfUrl: pdfUrl,
                    onOpen: () {
                      if (pdfUrl == null) return;
                      Navigator.of(context).push(
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
                  const LessonQuizCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? _resolvePdfUrl(String? pdfUrl) {
    if (pdfUrl == null || pdfUrl.trim().isEmpty) {
      return null;
    }
    if (pdfUrl.startsWith('http')) {
      return pdfUrl;
    }
    final cleaned = pdfUrl.startsWith('uploads/')
        ? pdfUrl.replaceFirst('uploads/', '')
        : pdfUrl;
    return '${EndPoint.uploadsBaseUrl}$cleaned';
  }
}