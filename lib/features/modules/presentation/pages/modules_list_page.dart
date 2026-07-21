// algonaid/lib/features/modules/presentation/pages/modules_list_page.dart

import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/di/service_locator.dart';
import 'package:algonaid/core/theme/borders.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/widgets/shared/app_snackbar.dart';
import 'package:algonaid/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/modules/presentation/widgets/buildExpertBadge.dart';
import 'package:algonaid/features/modules/presentation/widgets/progressInfo.dart';
import 'package:algonaid/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid/features/modules/presentation/widgets/moduleHaeder.dart';
import 'package:algonaid/features/modules/presentation/widgets/sliverListItemBuilder.dart';
import 'package:algonaid/features/modules/presentation/widgets/modules_error_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/features/modules/domain/entities/module.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/features/modules/data/datasources/module_local_datasource.dart';
import 'package:algonaid/features/modules/data/models/last_accessed_module_model.dart';
import 'package:algonaid/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid/features/practice_exams/presentation/widgets/practice_exams_tab_view.dart';

import 'package:algonaid/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:algonaid/core/widgets/shared/custom_threshold_refresh_indicator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';

class ModulesListPage extends StatefulWidget {
  const ModulesListPage({super.key, required this.course});

  final CourseEntity course;

  @override
  State<ModulesListPage> createState() => _ModulesListPageState();
}

class _ModulesListPageState extends State<ModulesListPage> {
  bool _isBackgroundRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ModulesListProvider>().loadModules(widget.course.id);
        if (widget.course.title == 'جاري تحميل الدورة...') {
          final isGuest = TokenStorage.getToken() == null;
          context.read<GetCoursesProvider>().refreshAll(isGuest: isGuest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ModulesListView(
      course: widget.course,
      isBackgroundRefreshing: _isBackgroundRefreshing,
      onRefresh: () async {
        setState(() => _isBackgroundRefreshing = true);
        final isGuest = TokenStorage.getToken() == null;
        await context.read<ModulesListProvider>().loadModules(widget.course.id);
        await context.read<GetCoursesProvider>().refreshAll(isGuest: isGuest);
        if (mounted) setState(() => _isBackgroundRefreshing = false);
      },
    );
  }
}

class _ModulesListView extends StatelessWidget {
  const _ModulesListView({
    required this.course,
    required this.isBackgroundRefreshing,
    required this.onRefresh,
  });
  final CourseEntity course;
  final bool isBackgroundRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Consumer<GetCoursesProvider>(
      builder: (context, coursesProvider, _) {
        CourseEntity updatedCourse = course;
        try {
          updatedCourse = coursesProvider.myCourses.cast<CourseEntity>().firstWhere(
            (c) => c.id == course.id,
            orElse: () => coursesProvider.allCourses.cast<CourseEntity>().firstWhere(
              (c) => c.id == course.id,
              orElse: () => course,
            ),
          );
        } catch (_) {}

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: context.background,
                body: Stack(
                  children: [
                    CustomThresholdRefreshIndicator(
                      elevation: 0.0,
                      color: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      strokeWidth: 0,
                      notificationPredicate: (ScrollNotification notification) {
                        return defaultScrollNotificationPredicate(notification) && notification.metrics.pixels <= 0;
                      },
                      onRefresh: onRefresh,
                      child: NestedScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            CourseHeaderSliver(
                              course: updatedCourse,
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverAppBarDelegate(
                                TabBar(
                                  labelColor: context.primary,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: context.primary,
                                  indicatorWeight: 3,
                                  tabs: const [
                                    Tab(text: "محتوى الدورة"),
                                    Tab(text: "التفاصيل"),
                                    Tab(text: "نماذج الاختبارات"),
                                  ],
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Consumer<ModulesListProvider>(
                          builder: (context, provider, _) {
                            final state = provider.state;
                            final modules = state.modules;

                            return TabBarView(
                              children: [
                                // Tab 1: Modules List & Progress
                                CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: CourseProgressInfo(
                                          totalCount: updatedCourse.totalLessons,
                                          completedCount: updatedCourse.completedLessons,
                                          progress: updatedCourse.progressPercentage,
                                          onContinueTap: () {
                                            final isGuest = TokenStorage.getToken() == null;
                                            if (isGuest) {
                                              AppSnackBar.show(
                                                context: context,
                                                message: 'عذراً، ميزة مواصلة التعلم غير متاحة في وضع الزائر. يرجى تسجيل الدخول لحفظ تقدمك! 🔒',
                                                type: SnackBarType.warning,
                                              );
                                              return;
                                            }
                                            if (modules.isEmpty) return;

                                            final lastLessonId = CacheHelper.getInt(key: 'last_lesson_course_${updatedCourse.id}');
                                            final lastModuleId = CacheHelper.getInt(key: 'last_module_course_${updatedCourse.id}');

                                            if (lastLessonId != null) {
                                              context.push(
                                                '${Routes.lessonDetails}/$lastLessonId',
                                                extra: lastModuleId != null
                                                    ? '${Routes.lessonsList}/$lastModuleId'
                                                    : '${Routes.coursesPage}',
                                              );
                                            } else {
                                              AppSnackBar.show(
                                                context: context,
                                                message: 'لم تبدأ بمشاهدة أي درس في هذه الدورة بعد. اختر أحد الدروس من القائمة أدناه للبدء بالتعلم! 📚',
                                                type: SnackBarType.info,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    if (state.isLoading)
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: context.primary,
                                          ),
                                        ),
                                      )
                                    else if (state.errorMessage != null)
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: ModulesErrorState(
                                            message: state.errorMessage!,
                                            onRetry: () => provider.loadModules(updatedCourse.id),
                                          ),
                                        ),
                                      )
                                    else if (modules.isEmpty)
                                      const SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: AppEmptyState(
                                          icon: Icons.folder_open_rounded,
                                          title: 'لا توجد وحدات',
                                          subtitle: 'لا توجد وحدات حالياً',
                                        ),
                                      )
                                    else
                                      SliverPadding(
                                        padding: const EdgeInsets.all(16),
                                        sliver: sliverListItemsBuilder(
                                          modules: modules,
                                          course: updatedCourse,
                                        ),
                                      ),
                                  ],
                                ),

                                // Tab 2: Course Details & Expert Badge
                                CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: _CourseDetailsSection(course: updatedCourse),
                                    ),
                                    SliverToBoxAdapter(
                                      child: BuildExpertBadge(courseId: updatedCourse.id),
                                    ),
                                  ],
                                ),

                                // Tab 3: Practice Exams
                                PracticeExamsTabView(courseId: updatedCourse.id),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 0,
                      right: 0,
                      child: Consumer<ModulesListProvider>(
                        builder: (context, provider, child) {
                          return SyncStatusIndicator(
                            isUpdating: isBackgroundRefreshing || provider.state.isBackgroundUpdating,
                            errorMessage: provider.state.errorMessage,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _CourseDetailsSection extends StatefulWidget {
  final CourseEntity course;

  const _CourseDetailsSection({Key? key, required this.course}) : super(key: key);

  @override
  State<_CourseDetailsSection> createState() => _CourseDetailsSectionState();
}

class _CourseDetailsSectionState extends State<_CourseDetailsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: AppBorder.main_border,
         
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 20, color: context.primary),
                const SizedBox(width: 8),
                Text(
                  'عن الدورة',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: _isExpanded ? double.infinity : 75,
                ),
                child: ClipRect(
                  child: MarkdownBody(
                    data: widget.course.description,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: context.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: context.isDarkMode ? Colors.grey[300] : Colors.grey[800],
                      ),
                      h1: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      h2: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      h3: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show "Read more" toggle only if description is long enough
            if (widget.course.description.length > 100)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    _isExpanded ? 'عرض أقل' : 'قراءة المزيد',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.1)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, size: 20, color: context.primary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المدرب',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.course.teacher.user.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
