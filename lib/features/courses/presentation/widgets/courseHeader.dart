import 'package:algonaid_mobile_app/core/widgets/loading/continueLearningShimmer.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/continue_learning_card.dart';
import 'package:algonaid_mobile_app/features/courses/presentation/widgets/welcomeNewUserCard.dart';
import 'package:algonaid_mobile_app/features/modules/presentation/providers/last_accessed_module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class courseHeader extends StatelessWidget {
  final bool hasEnrolledCourses;

  const courseHeader({super.key, required this.hasEnrolledCourses});

  @override
  Widget build(BuildContext context) {
    return Consumer<LastAccessedModuleProvider>(
      builder: (context, moduleProvider, child) {
        if (moduleProvider.isLoading) {
          return const ContinueLearningShimmer();
        }
        if (moduleProvider.lastAccessedModule != null && hasEnrolledCourses) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ContinueLearningCard(
              module: moduleProvider.lastAccessedModule!,
            ),
          );
        } else {
          return WelcomeCard();
        }
      },
    );
  }
}
