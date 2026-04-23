import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/linearProgress.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final Module module;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.module, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.background),
              boxShadow: AppShadows.cardShadow,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: context.isDarkMode
                      ? AppColors.textSecondaryDark
                      : AppColors.grey400,
                  size: 18,
                ),

                const SizedBox(width: 16),

                ModuleCardContent(module: module, theme: context.theme),

                const SizedBox(width: 12),

                ModulePercentageProgress(module: module),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModulePercentageProgress extends StatelessWidget {
  const ModulePercentageProgress({super.key, required this.module});

  final Module module;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? context.surfaceContainer
            : context.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        "${(module.progressPercentage).toInt()}%",
        style: TextStyle(
          color: context.primary,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }
}

class ModuleCardContent extends StatelessWidget {
  const ModuleCardContent({
    super.key,
    required this.module,
    required this.theme,
  });

  final Module module;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              module.title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              module.description,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgress(progressPercentage: module.progressPercentage),
        ],
      ),
    );
  }
}
