// algonaid_mobail_app/lib/features/modules/presentation/pages/modules_list_page.dart

import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/di/service_locator.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/pages/lessons_list_page.dart'; // Import LessonsListPage
import 'package:algonaid_mobail_app/features/modules/presentation/providers/modules_list_provider.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/module_card.dart';
import 'package:algonaid_mobail_app/features/modules/presentation/widgets/modules_error_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Duration _kFastMotionDuration = Duration(milliseconds: 200);
const Duration _kMediumMotionDuration = Duration(milliseconds: 300);
const Curve _kStandardMotionCurve = Curves.easeOutCubic;

class ModulesListPage extends StatelessWidget {
  final int courseId;
  final String courseTitle;

  const ModulesListPage({
    super.key,
    required this.courseId,
    this.courseTitle = 'الدورات',
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ModulesListProvider(getIt());
        provider.loadModules(courseId);
        return provider;
      },
      child: _ModulesListView(courseId: courseId, courseTitle: courseTitle),
    );
  }
}

class _ModulesListView extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const _ModulesListView({required this.courseId, required this.courseTitle});

  @override
  State<_ModulesListView> createState() => _ModulesListViewState();
}

class _ModulesListViewState extends State<_ModulesListView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(widget.courseTitle),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: Consumer<ModulesListProvider>(
          builder: (context, provider, _) {
            final state = provider.state;

            if (state.isLoading) {
              return AnimatedSwitcher(
                duration: _kFastMotionDuration,
                child: const Center(
                  key: ValueKey('loading'),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state.errorMessage != null) {
              return AnimatedSwitcher(
                duration: _kFastMotionDuration,
                child: ModulesErrorState(
                  key: const ValueKey('error'),
                  message: state.errorMessage!,
                  onRetry: () => provider.loadModules(widget.courseId),
                ),
              );
            }

            final modules = state.modules;
            if (modules.isEmpty) {
              return AnimatedSwitcher(
                duration: _kFastMotionDuration,
                child: const Center(
                  key: ValueKey('empty'),
                  child: Text('لا توجد وحدات حالياً'),
                ),
              );
            }

            return AnimatedSwitcher(
              duration: _kFastMotionDuration,
              child: ListView.separated(
                key: const ValueKey('list'),
                padding: const EdgeInsets.all(16),
                itemCount: modules.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return _AnimatedModuleItem(
                    index: index,
                    child: ModuleCard(
                      module: module,
                      onTap: () {
                        // Navigate to LessonsListPage when a module is tapped
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonsListPage(
                              moduleId: module.id,
                              moduleTitle: module.title,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedModuleItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedModuleItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final base = _kMediumMotionDuration;
    final extra = Duration(milliseconds: (index % 6) * 40);
    final duration = base + extra;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: _kStandardMotionCurve,
      builder: (context, value, child) {
        final translate = 12 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translate),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
