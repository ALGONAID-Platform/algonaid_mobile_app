// algonaid_mobail_app/lib/features/modules/presentation/pages/modules_list_page.dart

import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/buildExpertBadge.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/progressInfo.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/moduleHaeder.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/sliverListItemBuilder.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/modules_error_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:provider/provider.dart';

class ModulesListPage extends StatelessWidget {
  const ModulesListPage({super.key, required this.course});

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ModulesListProvider(getIt());
        provider.loadModules(course.id);
        return provider;
      },
      child: _ModulesListView(course: course),
    );
  }
}

class _ModulesListView extends StatelessWidget {
  const _ModulesListView({required this.course});
  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: context.background,
            body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  CourseHeaderSliver(
                    title: course.title,
                    imageUrl: course.thumbnail,
                    courseId: course.id,
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
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CourseProgressInfo(
                                totalCount: course.totalLessons,
                                completedCount: course.completedLessons,
                                progress: course.progressPercentage,
                                onContinueTap: () {
                                  if (modules.isEmpty) return;
                                  
                                  final lastModuleId = CacheHelper.getInt(key: 'last_module_course_${course.id}');
                                  
                                  if (lastModuleId != null) {
                                    final lastLessonId = CacheHelper.getInt(key: 'last_lesson_module_$lastModuleId');
                                    
                                    if (lastLessonId != null) {
                                      context.push(
                                        '${Routes.lessonDetails}/$lastLessonId',
                                        extra: '${Routes.lessonsList}/$lastModuleId',
                                      ).then((_) {
                                        if (context.mounted) {
                                          try {
                                            context.read<ModulesListProvider>().loadModules(course.id);
                                            context.read<GetCoursesProvider>().refreshAll();
                                          } catch (_) {}
                                        }
                                      });
                                      return;
                                    } else {
                                      try {
                                        final m = modules.firstWhere((m) => m.id == lastModuleId);
                                        context.push(
                                          '${Routes.lessonsList}/${m.id}',
                                          extra: {
                                            'moduleTitle': m.title,
                                            'completedLessons': m.completedLessons,
                                            'progressPercentage': m.progressPercentage,
                                            'totalLessons': m.totalLessons,
                                          },
                                        ).then((_) {
                                          if (context.mounted) {
                                            try {
                                              context.read<ModulesListProvider>().loadModules(course.id);
                                              context.read<GetCoursesProvider>().refreshAll();
                                            } catch (_) {}
                                          }
                                        });
                                        return;
                                      } catch (_) {}
                                    }
                                  }

                                  // Fallback logic
                                  Module? targetModule;
                                  try {
                                    targetModule = modules.firstWhere((m) => m.progressPercentage < 100);
                                  } catch (_) {
                                    targetModule = modules.last;
                                  }
                                  
                                  context.push(
                                    '${Routes.lessonsList}/${targetModule.id}',
                                    extra: {
                                      'moduleTitle': targetModule.title,
                                      'completedLessons': targetModule.completedLessons,
                                      'progressPercentage': targetModule.progressPercentage,
                                      'totalLessons': targetModule.totalLessons,
                                    },
                                  ).then((_) {
                                    if (context.mounted) {
                                      try {
                                        context.read<ModulesListProvider>().loadModules(course.id);
                                        context.read<GetCoursesProvider>().refreshAll();
                                      } catch (_) {}
                                    }
                                  });
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
                                  onRetry: () => provider.loadModules(course.id),
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
                              sliver: sliverListItemsBuilder(modules: modules),
                            ),
                        ],
                      ),

                      // Tab 2: Course Details & Expert Badge
                      CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: _CourseDetailsSection(course: course),
                          ),
                          SliverToBoxAdapter(
                            child: BuildExpertBadge(courseId: course.id),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
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
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Text(
                widget.course.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: context.isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              secondChild: Text(
                widget.course.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: context.isDarkMode ? Colors.grey[300] : Colors.grey[800],
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
