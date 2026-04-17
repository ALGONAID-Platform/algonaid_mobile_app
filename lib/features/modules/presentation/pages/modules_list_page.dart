// algonaid_mobail_app/lib/features/modules/presentation/pages/modules_list_page.dart

import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/buildExpertBadge.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/progressInfo.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/animatedModuleItem.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/courseHeader.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ModulesListPage extends StatelessWidget {
  final int courseId;
  final String courseTitle;
  final String courseImage;
  const ModulesListPage({
    super.key,
    required this.courseId,
    this.courseTitle = 'الدورات',
    this.courseImage = '',
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ModulesListProvider(getIt());
        provider.loadModules(courseId);
        return provider;
      },
      child: _ModulesListView(
        courseId: courseId,
        courseTitle: courseTitle,
        courseImage: courseImage,
      ),
    );
  }
}

class _ModulesListView extends StatelessWidget {
  final int courseId;
  final String courseTitle;
  final String? courseImage;

  const _ModulesListView({
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7F9), // لون خلفية هادئ

          body: Consumer<ModulesListProvider>(
            builder: (context, provider, _) {
              final state = provider.state;

              final modules = state.modules;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Course Header
                  CourseHeaderSliver(
                    title: courseTitle,
                    imageUrl: courseImage,

                    onBackTap: () {},
                    onContinueTap: () {},
                  ),
                  SliverToBoxAdapter(
                    child: CourseProgressInfo(
                      totalCount: 20,
                      completedCount: 6,
                      progress: 0.5,
                    ),
                  ),
                  // Expert badge
                  SliverToBoxAdapter(
                    child: BuildExpertBadge(
                      title: "وسام خبير المادة",
                      description: "أكمل 100% من الوحدة بمتوسط 90%",
                      iconColor: AppColors.primary,
                      gradientColors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],

                      borderColor: AppColors.primary,
                      cardBackgroundColor: AppColors.primary.withOpacity(0.05),
                      cardBorderColor: AppColors.primary.withOpacity(0.2),
                      statusTagColor: AppColors.primary,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.5),
                          builder: (context) => Badge3DDialog(
                            heroTag: "expert_badge_$courseId",
                            title: "وسام خبير المادة",
                            description: "أكمل 100% من الوحدة بمتوسط 90%",
                            iconColor: AppColors.white,
                            gradientColors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                            borderColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),

                  //modules list
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final module = modules[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedModuleItem(
                            index: index,
                            child: ModuleCard(
                              module: module,
                              onTap: () async {
                                GoRouter.of(context).push(
                                  '${Routes.lessonsList}/${module.id}',
                                  extra: {'moduleTitle': module.title},
                                );
                              },
                            ),
                          ),
                        );
                      }, childCount: modules.length),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
