import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/theme.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/usecases/get_lesson_detail.dart';
import 'package:algonaid_mobail_app/features/lessons/data/services/lesson_download_service.dart';
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
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LessonDetailProvider(
          context.read<GetLessonDetail>(),
          context.read<LessonDownloadService>(),
        );
        provider.loadLesson(lessonId);
        return provider;
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
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Consumer<LessonDetailProvider>(
            builder: (context, provider, _) {
              final state = provider.state;
              final isDownloaded = state.isDownloaded;
              final isDownloading = state.isDownloading;
              final hasLesson = state.lesson != null;
              final actionLabel = isDownloaded ? 'حذف الدرس' : 'تحميل الدرس';
              final actionIcon =
                  isDownloaded ? Icons.delete_outline : Icons.download;

              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: !hasLesson || isDownloading
                          ? null
                          : () async {
                              final result = isDownloaded
                                  ? await provider.deleteDownloadedLesson()
                                  : await provider.downloadLesson();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.message)),
                              );
                            },
                      icon: isDownloading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(actionIcon),
                      label: Text(actionLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDownloaded
                            ? AppColors.red
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.list_alt),
                      label: const Text('قائمة الدروس'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigoDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Consumer<LessonDetailProvider>(
          builder: (context, provider, _) {
            final motion =
                Theme.of(context).extension<MotionTheme>() ??
                    MotionTheme.defaults;
            final state = provider.state;
            if (state.isLoading) {
              return AnimatedSwitcher(
                duration: motion.fast,
                child: const Center(
                  key: ValueKey('loading'),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state.errorMessage != null) {
              return AnimatedSwitcher(
                duration: motion.fast,
                child: Center(
                  key: const ValueKey('error'),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            final lesson = state.lesson;
            if (lesson == null) {
              return AnimatedSwitcher(
                duration: motion.fast,
                child: const Center(
                  key: ValueKey('empty'),
                  child: Text('تعذر تحميل الدرس'),
                ),
              );
            }

            final pdfUrl = _resolvePdfUrl(lesson.pdfUrl);

            return AnimatedSwitcher(
              duration: motion.medium,
              transitionBuilder: (child, animation) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: motion.standard,
                );
                return FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(curved),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                key: const ValueKey('content'),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StaggeredFade(
                      order: 0,
                      child: LessonVideoPlayer(videoUrl: lesson.videoUrl),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredFade(
                      order: 1,
                      child: LessonInfoCard(title: lesson.title),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredFade(
                      order: 2,
                      child: LessonTabs(
                        description: lesson.description,
                        content: lesson.content,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StaggeredFade(
                      order: 3,
                      child: LessonPdfCard(
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
                    ),
                    const SizedBox(height: 16),
                    _StaggeredFade(
                      order: 4,
                      child: const LessonQuizCard(),
                    ),
                  ],
                ),
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

class _StaggeredFade extends StatelessWidget {
  final int order;
  final Widget child;

  const _StaggeredFade({
    required this.order,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final motion =
        Theme.of(context).extension<MotionTheme>() ?? MotionTheme.defaults;
    final delay = Duration(milliseconds: order * 60);
    final duration = motion.medium + delay;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: motion.standard,
      builder: (context, value, child) {
        final translate = 10 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translate),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
