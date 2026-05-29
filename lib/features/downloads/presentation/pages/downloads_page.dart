import 'dart:io';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/features/downloads/presentation/providers/downloads_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DownloadsProvider>().fetchDownloadedLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        body: Consumer<DownloadsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            }

            if (provider.downloadedCourses.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: provider.fetchDownloadedLessons,
              color: context.primary,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 16, left: 16, right: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.downloadedCourses.length,
                itemBuilder: (context, index) {
                  final course = provider.downloadedCourses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _CourseCard(course: course),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // تصميم الواجهة الفارغة بشكل إبداعي ومريح للعين
  Widget _buildEmptyState(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.cloud_download_outlined,
      title: 'لا توجد دروس محملة حالياً',
      subtitle: 'الدروس التي تقوم بتحميلها ستظهر هنا للوصول إليها بدون إنترنت',
    );
  }
}

class _CourseCard extends StatefulWidget {
  final DownloadedCourseItem course;

  const _CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: AppBorder.main_border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    // أيقونة الكورس مع حاوية ملونة لطيفة
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.auto_stories_rounded, color: context.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.course.title,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.course.modules.length} وحدات دراسية ممتدة',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: context.colorScheme.onSurface.withOpacity(0.4),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // الأنيميشن الخاص بفتح قائمة الوحدات والدروس
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Container(
                      color: context.colorScheme.surfaceContainerLow.withOpacity(0.4),
                      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                      child: Column(
                        children: widget.course.modules
                            .map((m) => _buildModuleTile(context, m))
                            .toList(),
                      ),
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }

  // بناء تبويب الوحدة الدراسية بأسلوب شجري أنيق
  Widget _buildModuleTile(BuildContext context, DownloadedModuleItem module) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    module.title,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // عرض الدروس التابعة لهذه الوحدة
          ...module.lessons.map((l) => _buildLessonTile(context, l)),
        ],
      ),
    );
  }

  // بناء حقل الدرس المنفرد بشكل عصري
  Widget _buildLessonTile(BuildContext context, DownloadedLessonItem lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.onSurface.withOpacity(0.04),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.push('${Routes.lessonDetails}/${lesson.lessonId}');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // تغيير الأيقونة مع الخلفية حسب نوع الدرس بشكل تفاعلي
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: lesson.hasVideo 
                        ? Colors.red.withOpacity(0.08) 
                        : Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    lesson.hasVideo ? Icons.play_circle_filled_rounded : Icons.description_rounded,
                    color: lesson.hasVideo ? Colors.redAccent : Colors.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_left_rounded,
                  color: context.colorScheme.onSurface.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}