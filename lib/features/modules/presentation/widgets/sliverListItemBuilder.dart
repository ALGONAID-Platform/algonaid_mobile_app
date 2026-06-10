import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/providers/get_courses_provider.dart';
import 'package:algonaid_mobile_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/widgets/animatedModuleItem.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/widgets/module_card.dart';
import 'package:algonaid_mobile_app/features/modules/data/datasources/module_local_datasource.dart';
import 'package:algonaid_mobile_app/features/modules/data/models/last_accessed_module_model.dart';
import 'package:algonaid_mobile_app/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algonaid_mobile_app/core/utils/cache/shared_pref.dart';
import 'package:provider/provider.dart';

class sliverListItemsBuilder extends StatelessWidget {
  const sliverListItemsBuilder({
    super.key,
    required this.modules,
    required this.course,
  });

  final List<Module> modules;
  final CourseEntity course;

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
                final lastAccessed = LastAccessedModuleModel(
                  moduleId: module.id,
                  courseName: course.title,
                  moduleName: module.title,
                  moduleDescription: module.description,
                  totalLessons: module.totalLessons,
                  completedLessons: module.completedLessons,
                  progressPercentage: module.progressPercentage,
                  image_url: course.thumbnail,
                );

                try {
                  await getIt<ModuleLocalDataSource>().cacheLastAccessedModule(lastAccessed);
                } catch (_) {}

                if (!context.mounted) return;

                try {
                  context.read<LastAccessedModuleProvider>().updateLastAccessedModule(lastAccessed);
                } catch (_) {}

                await CacheHelper.saveData(key: 'last_module_course_${module.courseId}', value: module.id);
                if (!context.mounted) return;
                GoRouter.of(context).push(
                  '${Routes.lessonsList}/${module.id}',
                  extra: {
                    'moduleTitle': module.title,
                    'completedLessons': module.completedLessons,
                    'progressPercentage': module.progressPercentage,
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
