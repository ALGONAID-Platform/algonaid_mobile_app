import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:flutter/material.dart';

class LessonInfoCard extends StatelessWidget {
  final String title;
  final bool hasVideo;

  const LessonInfoCard({super.key, required this.title, this.hasVideo = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: hasVideo ? 12 : 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      margin: hasVideo ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: hasVideo 
            ? const BorderRadius.vertical(bottom: Radius.circular(18))
            : BorderRadius.circular(18),
        border: hasVideo 
            ? Border(
                bottom: BorderSide(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05)),
                left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05)),
                right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.05)),
              )
            : AppBorder.main_border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
