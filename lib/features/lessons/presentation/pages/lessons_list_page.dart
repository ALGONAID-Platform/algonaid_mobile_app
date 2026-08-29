import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/constants/endpoints.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid/features/lessons/presentation/widgets/lessonHeader.dart';
import 'package:algonaid/features/lessons/presentation/widgets/moduleTimelineList.dart';
import 'package:algonaid/features/lessons/presentation/widgets/textDivider.dart';
import 'package:algonaid/features/lessons/presentation/widgets/lessons_error_state.dart';
import 'package:algonaid/features/lessons/presentation/providers/lessons_list_provider.dart';
import 'package:algonaid/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/widgets/shared/app_empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid/core/utils/cache/shared_pref.dart';
import 'package:algonaid/core/utils/hive/token_storage.dart';
import 'package:algonaid/core/widgets/shared/guest_login_dialog.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/features/courses/presentation/widgets/sync_status_indicator.dart';
import 'package:algonaid/core/widgets/shared/custom_threshold_refresh_indicator.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

class LessonsListPage extends StatefulWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final int? courseId;
  final String? previousRoute;
  final String? moduleDescription;
  final String? imageUrl;

  const LessonsListPage({
    super.key,
    required this.moduleId,
    this.moduleTitle = 'الوحدة',
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.courseId,
    this.previousRoute,
    this.moduleDescription,
    this.imageUrl,
  });

  @override
  State<LessonsListPage> createState() => _LessonsListPageState();
}

class _LessonsListPageState extends State<LessonsListPage> {
  bool _isBackgroundRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LessonsListProvider>().loadLessons(widget.moduleId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // تحميل المزيد فقط عند الاقتراب من آخر القائمة وبشرط وجود صفحات إضافية
    if (maxScroll > 0 && currentScroll >= maxScroll - 50) {
      final provider = context.read<LessonsListProvider>();
      if (!provider.state.isFetchingNextPage &&
          !provider.state.isLoading &&
          provider.state.hasMorePages) {
        provider.loadLessons(widget.moduleId, loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LessonsListView(
      moduleId: widget.moduleId,
      moduleTitle: widget.moduleTitle,
      completedLessons: widget.completedLessons,
      progressPercentage: widget.progressPercentage,
      totalLessons: widget.totalLessons,
      courseId: widget.courseId,
      previousRoute: widget.previousRoute,
      moduleDescription: widget.moduleDescription,
      imageUrl: widget.imageUrl,
      isBackgroundRefreshing: _isBackgroundRefreshing,
      scrollController: _scrollController,
      onRefresh: () async {
        setState(() => _isBackgroundRefreshing = true);
        final isGuest = TokenStorage.getToken() == null;
        await context.read<LessonsListProvider>().loadLessons(widget.moduleId);
        await context.read<GetCoursesProvider>().refreshAll(isGuest: isGuest);
        if (mounted) setState(() => _isBackgroundRefreshing = false);
      },
    );
  }
}

class _LessonsListView extends StatelessWidget {
  final int moduleId;
  final String moduleTitle;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;
  final int? courseId;
  final String? previousRoute;
  final String? moduleDescription;
  final String? imageUrl;
  final bool isBackgroundRefreshing;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  const _LessonsListView({
    required this.moduleId,
    required this.moduleTitle,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
    this.courseId,
    this.previousRoute,
    this.moduleDescription,
    this.imageUrl,
    required this.isBackgroundRefreshing,
    required this.onRefresh,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
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
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // الهيدر الذي يحتوي على الإحصائيات وزر الرجوع
                    SliverToBoxAdapter(
                      child: Consumer<ModulesListProvider>(
                        builder: (context, provider, child) {
                          var currentTotal = totalLessons;
                          var currentCompleted = completedLessons;
                          var currentProgress = progressPercentage;

                          try {
                            final currentModule = provider.state.modules.firstWhere((m) => m.id == moduleId);
                            currentTotal = currentModule.totalLessons;
                            currentCompleted = currentModule.completedLessons;
                            currentProgress = currentModule.progressPercentage;
                          } catch (_) {
                            // Fallback to widget properties if not found
                          }

                          String? resolvedUrl = imageUrl;
                          if (resolvedUrl != null && resolvedUrl.isNotEmpty && !resolvedUrl.startsWith('http')) {
                            resolvedUrl = resolvedUrl.startsWith('/')
                                ? '${EndPoint.uploadsBaseUrl}$resolvedUrl'
                                : '${EndPoint.uploadsBaseUrl}/$resolvedUrl';
                          }

                          return ModuleHeaderStats(
                            completedLessons: currentCompleted,
                            moduleId: moduleId,
                            progressPercentage: currentProgress,
                            moduleTitle: moduleTitle,
                            moduleDescription: moduleDescription,
                            totalLessons: currentTotal,
                            imageUrl: resolvedUrl,
                            onBack: () => _handleBackNavigation(context),
                            scrollController: scrollController,
                          );
                        },
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: TextDivider(totalLessons: totalLessons),
                    ),

                    Consumer<LessonsListProvider>(
                      builder: (context, provider, _) {
                        final state = provider.state;

                        if (state.isLoading) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state.errorMessage != null) {
                          return SliverFillRemaining(
                            child: LessonsErrorState(
                              message: state.errorMessage!,
                              onRetry: () => context
                                  .read<LessonsListProvider>()
                                  .loadLessons(moduleId),
                            ),
                          );
                        }

                        final lessons = state.lessons;

                        if (lessons.isEmpty) {
                          return const SliverFillRemaining(
                            child: AppEmptyState(
                              icon: Icons.menu_book_rounded,
                              title: 'لا توجد دروس',
                              subtitle: 'لا توجد دروس حالياً',
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final lessonData = lessons[index];
                              // Only mark as last if it's the last item AND no more pages
                              final isLastItem = index == lessons.length - 1 && !state.hasMorePages;
                              return LessonTimelineItem(
                                lesson: lessonData,
                                isLast: isLastItem,
                                onTap: () async {
                                  final token = TokenStorage.getToken();
                                  final isGuest = token == null || token.trim().isEmpty;
                                  if (isGuest) {
                                    showGuestLoginDialog(
                                      context,
                                      title: 'مشاهدة الدرس تتطلب تسجيل الدخول',
                                      message: 'يرجى تسجيل الدخول لتتمكن من مشاهدة محتوى هذا الدرس والمتابعة في التعلم.',
                                      onLogin: () {
                                        context.read<AuthServiceProvider>().setAuthMode(true);
                                        context.push(Routes.auth);
                                      },
                                    );
                                    return;
                                  }

                                  await CacheHelper.saveData(
                                    key: 'last_lesson_module_$moduleId',
                                    value: lessonData.id,
                                  );
                                  if (courseId != null) {
                                    await CacheHelper.saveData(
                                      key: 'last_lesson_course_$courseId',
                                      value: lessonData.id,
                                    );
                                    await CacheHelper.saveData(
                                      key: 'last_module_course_$courseId',
                                      value: moduleId,
                                    );
                                  }
                                  if (!context.mounted) return;
                                  GoRouter.of(context).push(
                                    '${Routes.lessonDetails}/${lessonData.id}',
                                    extra: '${Routes.lessonsList}/$moduleId',
                                  );
                                },
                              );
                            }, childCount: lessons.length),
                          ),
                        );
                      },
                    ),
                    // Loading indicator when fetching next page
                    Consumer<LessonsListProvider>(
                      builder: (context, provider, _) {
                        final state = provider.state;
                        if (state.isFetchingNextPage) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(strokeWidth: 3),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'جارٍ تحميل المزيد من الدروس...',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        // The static 'hasMorePages' indicator is removed since we always try to load dynamically.
                        return const SliverToBoxAdapter(child: SizedBox.shrink());
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Consumer<LessonsListProvider>(
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
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      final fallbackRoute = previousRoute ?? Routes.coursesPage;
      GoRouter.of(context).go(fallbackRoute);
    }
  }
}
