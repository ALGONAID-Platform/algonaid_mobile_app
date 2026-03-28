import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/cubits/lesson_detail_cubit.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_info_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_pdf_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_quiz_card.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_tabs.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/widgets/lesson_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonDetailPage extends StatelessWidget {
  final int lessonId;

  const LessonDetailPage({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = LessonDetailCubit(
          context.read<GetLessonDetail>(),
        );
        cubit.loadLesson(lessonId);
        return cubit;
      },
      child: const _LessonDetailView(),
    );
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
        body: BlocBuilder<LessonDetailCubit, LessonDetailState>(
          builder: (context, state) {
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
