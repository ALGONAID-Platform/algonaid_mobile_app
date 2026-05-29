
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/animatedModuleItem.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                GoRouter.of(context).push(
                  '${Routes.lessonsList}/${module.id}',
                  extra: {
                    'moduleTitle': module.title,
                    'completedLessons': module.completedLessons,
                    'progressPercentage':
                        module.progressPercentage,
                    'totalLessons': module.totalLessons,
                  },
                );
              },
            ),
          ),
        );
      }, childCount: modules.length),
    );
  }
}
