// algonaid_mobail_app/lib/features/modules/presentation/pages/modules_list_page.dart

import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/buildExpertBadge.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/expertBadge3D.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/progressInfo.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/animatedModuleItem.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/moduleHaeder.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/module_card.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/sliverListItemBuilder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        child: Scaffold(
               backgroundColor: context.background,

          body: Consumer<ModulesListProvider>(
            builder: (context, provider, _) {
              final state = provider.state;

              final modules = state.modules;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Course Header
                  CourseHeaderSliver(
                    title: course.title,
                    imageUrl: course.thumbnail,
                    courseId: course.id,
                    onBackTap: () {},
                    onContinueTap: () {},
                  ),
                  SliverToBoxAdapter(
                    child: CourseProgressInfo(
                      totalCount: course.totalLessons,
                      completedCount: course.completedLessons,
                      progress: course.progressPercentage,
                    ),
                  ),
                  // Expert badge
                  SliverToBoxAdapter(child: BuildExpertBadge()),

                  //modules list
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: sliverListItemsBuilder(modules: modules),
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
