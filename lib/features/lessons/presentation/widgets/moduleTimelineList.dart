import 'package:algonaid_mobile_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobile_app/core/common/extensions/lession_status.dart';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobile_app/core/theme/borders.dart';
import 'package:algonaid_mobile_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobile_app/core/theme/colors.dart';
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
            _buildTimelineIndicator(isLast, lesson.status, lesson.isReading, context),

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
                          border: AppBorder.main_border,
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
                                  context,
                                  lesson.status.label,
                                  lesson.status.getStatusColor(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                final typeText = lesson.isReading ? 'قراءة' : 'فيديو';
                                final typeIcon = lesson.isReading ? Icons.menu_book_rounded : Icons.play_circle_outline_rounded;
                                
                                return Row(
                                  children: [
                                    Icon(typeIcon, size: 14, color: AppColors.textSecondaryLight),
                                    const SizedBox(width: 4),
                                    Text(
                                      typeText,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondaryLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (lesson.hasTest || lesson.hasExam) ...[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          '•',
                                          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                        ),
                                      ),
                                      const Icon(Icons.edit_document, size: 14, color: AppColors.textSecondaryLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        'يتضمن اختبار',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              }
                            ),
                            const SizedBox(height: 16),
                            _customButton(
                              _getButtonText(lesson.status, lesson.isReading),
                              lesson.status.getStatusColor(context),
                              isOutlined: true,
                              icon: _getButtonIcon(lesson.status, lesson.isReading),
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
    bool isReading,
    BuildContext context,
  ) {
    final Color iconColor = status.getStatusColor(context);

    final Color lineColor = (status == LessonStatus.completed)
        ? Colors.green.withOpacity(0.5)
        : context.outline.withOpacity(0.3);

    return Column(
      children: [
        Icon(_getTimelineIcon(status, isReading), color: iconColor, size: 32),

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

  Widget _buildStatusTag(BuildContext context, String text, Color color, {bool isFloating = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFloating ? Theme.of(context).colorScheme.surface : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isFloating ? Border.all(color: color.withOpacity(0.3)) : null,
        boxShadow: isFloating ? AppShadows.cardShadow : null,
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

  Widget _buildTypeTag(String text, BuildContext context, {IconData? icon, Color? color, bool isFloating = false}) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isFloating ? Theme.of(context).colorScheme.surface : themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isFloating ? Border.all(color: themeColor.withOpacity(0.3)) : null,
        boxShadow: isFloating ? AppShadows.cardShadow : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: themeColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: themeColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton(
    String text,
    Color color, {
    required bool isOutlined,
    IconData? icon,
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
          if (icon != null) ...[
            Icon(icon, size: 16, color: isOutlined ? color : Colors.white),
            const SizedBox(width: 8),
          ],
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

  IconData _getTimelineIcon(LessonStatus status, bool isReading) {
    if (!isReading) return status.timeLineIcons;
    switch (status) {
      case LessonStatus.locked:
        return Icons.lock_outline;
      case LessonStatus.notStarted:
        return Icons.menu_book_outlined;
      case LessonStatus.inProgress:
        return Icons.menu_book;
      case LessonStatus.completed:
        return Icons.menu_book;
    }
  }

  String _getButtonText(LessonStatus status, bool isReading) {
    if (isReading && status == LessonStatus.completed) {
      return 'اكتملت القراءة';
    }
    return status.buttonText;
  }

  IconData? _getButtonIcon(LessonStatus status, bool isReading) {
    if (!isReading) return status.buttonIcon;
    switch (status) {
      case LessonStatus.completed:
        return null; // Remove the refresh icon for completed reading lessons
      case LessonStatus.inProgress:
        return Icons.menu_book;
      case LessonStatus.notStarted:
        return Icons.menu_book_outlined;
      case LessonStatus.locked:
        return Icons.lock_outline;
    }
  }
}
