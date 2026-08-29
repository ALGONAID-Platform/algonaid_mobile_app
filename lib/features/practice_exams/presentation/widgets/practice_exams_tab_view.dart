import 'dart:async';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid/features/lesson_detail/presentation/pages/lesson_pdf_viewer_page.dart';
import 'package:algonaid/features/practice_exams/presentation/providers/practice_exams_provider.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PracticeExamsTabView extends StatefulWidget {
  final int courseId;

  const PracticeExamsTabView({super.key, required this.courseId});

  @override
  State<PracticeExamsTabView> createState() => _PracticeExamsTabViewState();
}

class _PracticeExamsTabViewState extends State<PracticeExamsTabView> {
  bool _isSelectionMode = false;
  final Set<int> _selectedExamIds = {};
  
  Timer? _fabTimer;
  double _fabOpacity = 0.3;

  @override
  void initState() {
    super.initState();
    _startFabTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final isGuest = TokenStorage.getToken() == null;
        if (!isGuest) {
          context.read<PracticeExamsProvider>().fetchPracticeExams(widget.courseId);
        }
      }
    });
  }

  void _onScroll() {
    if (_fabOpacity != 1.0) {
      setState(() {
        _fabOpacity = 1.0;
      });
    }
    _startFabTimer();
  }

  void _startFabTimer() {
    _fabTimer?.cancel();
    _fabTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _fabOpacity = 0.3;
        });
      }
    });
  }

  @override
  void dispose() {
    _fabTimer?.cancel();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedExamIds.clear();
      }
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedExamIds.contains(id)) {
        _selectedExamIds.remove(id);
      } else {
        _selectedExamIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = TokenStorage.getToken() == null;
    if (isGuest) {
      return const AppEmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'الوصول محدود',
        subtitle: 'يرجى تسجيل الدخول لتتمكن من استعراض وتحميل نماذج الاختبارات.',
      );
    }

    return Consumer<PracticeExamsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: context.primary),
          );
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchPracticeExams(widget.courseId);
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.exams.isEmpty) {
          return const AppEmptyState(
            icon: Icons.assignment_outlined,
            title: 'لا توجد نماذج',
            subtitle: 'لا توجد نماذج اختبارات متاحة لهذه الدورة حالياً',
          );
        }

        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  _onScroll();
                }
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'النماذج المتاحة (${provider.exams.length})',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _toggleSelectionMode,
                            icon: Icon(
                              _isSelectionMode ? Icons.close : Icons.checklist,
                              color: context.primary,
                            ),
                            label: Text(
                              _isSelectionMode ? 'إلغاء التحديد' : 'تحديد للتحميل',
                              style: TextStyle(color: context.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isSelectionMode)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _selectedExamIds.isNotEmpty && _selectedExamIds.length == provider.exams.where((e) => !provider.downloadedExams.containsKey(e.id)).length,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedExamIds.addAll(
                                      provider.exams
                                          .where((e) => !provider.downloadedExams.containsKey(e.id))
                                          .map((e) => e.id)
                                    );
                                  } else {
                                    _selectedExamIds.clear();
                                  }
                                });
                              },
                            ),
                            const Text('تحديد الكل'),
                          ],
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                      bottom: _isSelectionMode ? 80.0 : 16.0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final exam = provider.exams[index];
                          final isDownloaded = provider.downloadedExams.containsKey(exam.id);
                          final downloadProgress = provider.downloadingProgress[exam.id];
                          final isDownloading = downloadProgress != null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onLongPress: () {
                                if (!_isSelectionMode && !isDownloaded) {
                                  _toggleSelectionMode();
                                  _toggleSelection(exam.id);
                                }
                              },
                              onTap: () {
                                if (_isSelectionMode) {
                                  if (!isDownloaded) {
                                    _toggleSelection(exam.id);
                                  }
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => LessonPdfViewerPage(
                                        pdfUrl: exam.pdfUrl,
                                        localPdfPath: provider.downloadedExams[exam.id],
                                        title: exam.title,
                                      ),
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _selectedExamIds.contains(exam.id)
                                      ? context.primary.withOpacity(0.05)
                                      : context.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: AppBorder.main_border,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_isSelectionMode)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                                        child: Checkbox(
                                          value: _selectedExamIds.contains(exam.id),
                                          onChanged: isDownloaded ? null : (val) {
                                            _toggleSelection(exam.id);
                                          },
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: context.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: context.primary,
                                            size: 32,
                                          ),
                                          if (isDownloaded)
                                            Positioned(
                                              bottom: -4,
                                              right: -4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2),
                                                ),
                                                child: const Icon(Icons.check, size: 12, color: Colors.white),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exam.title,
                                            style: context.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            exam.description,
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.grey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  exam.grade,
                                                  style: context.textTheme.labelSmall?.copyWith(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              if (isDownloading)
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    value: downloadProgress > 0 ? downloadProgress : null,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!_isSelectionMode)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 12.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: provider.exams.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isSelectionMode && _selectedExamIds.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                child: AnimatedOpacity(
                  opacity: _fabOpacity,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    onPressed: () {
                      final selectedExamsList = provider.exams.where((e) => _selectedExamIds.contains(e.id)).toList();
                      provider.downloadExams(selectedExamsList, context);
                      _toggleSelectionMode(); // Exit selection mode after triggering download
                    },
                    backgroundColor: context.colorScheme.error,
                    elevation: 0,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.download_rounded, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
