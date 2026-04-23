import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobail_app/core/common/extensions/lession_status.dart';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:flutter/material.dart';

class LessonTimelineItem extends StatelessWidget {
  final Lesson lesson;
  final bool isLast;
  final VoidCallback onTap;

  const LessonTimelineItem({
    super.key,
    required this.lesson,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimelineIndicator(isLast, lesson.status, context),

            const SizedBox(width: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.colorScheme.background),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                lesson.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            _buildStatusTag(
                              lesson.status.label,
                              lesson.status.getStatusColor(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _customButton(
                          lesson.status.buttonText,
                          lesson.status.getStatusColor(context),
                          isOutlined: true,
                          icon: lesson.status.buttonIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator(
    bool isLast,
    LessonStatus status,
    BuildContext context,
  ) {
    final Color iconColor = status.getStatusColor(context);

    final Color lineColor = (status == LessonStatus.completed)
        ? Colors.green.withOpacity(0.5)
        : context.outline.withOpacity(0.3);

    return Column(
      children: [
        Icon(status.timeLineIcons, color: iconColor, size: 32),

        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _customButton(
    String text,
    Color color, {
    required bool isOutlined,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(10),
        border: isOutlined ? Border.all(color: color) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: isOutlined ? color : Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isOutlined
                  ? color
                  : const Color.fromARGB(255, 137, 42, 42),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
