
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/animatedModuleItem.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:provider/provider.dart';

class sliverListItemsBuilder extends StatelessWidget {
  const sliverListItemsBuilder({
    super.key,
    required this.modules,
  });

  final List<Module> modules;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final module = modules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedModuleItem(
            index: index,
            child: ModuleCard(
              module: module,
              onTap: () async {
                await CacheHelper.saveData(key: 'last_module_course_${module.courseId}', value: module.id);
                if (!context.mounted) return;
                GoRouter.of(context).push(
                  '${Routes.lessonsList}/${module.id}',
                  extra: {
                    'moduleTitle': module.title,
                    'completedLessons': module.completedLessons,
                    'progressPercentage':
                        module.progressPercentage,
                    'totalLessons': module.totalLessons,
                  },
                ).then((_) {
                  if (context.mounted) {
                    try {
                      context.read<ModulesListProvider>().loadModules(module.courseId);
                      context.read<GetCoursesProvider>().refreshAll();
                    } catch (_) {}
                  }
                });
              },
            ),
          ),
        );
      }, childCount: modules.length),
    );
  }
}
