import 'package:algonaid_mobail_app/core/common/enums/lesson_status.dart';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

extension LessonStatusHelper on LessonStatus {
  String get label {
    switch (this) {
      case LessonStatus.notStarted:
        return "لم يبدأ";
      case LessonStatus.inProgress:
        return "قيد التعلم";
      case LessonStatus.completed:
        return "مكتمل";
      case LessonStatus.locked:
        return "مغلق";
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (this) {
      case LessonStatus.notStarted:
        return context.outline;
      case LessonStatus.inProgress:
        return const Color(0xFF00B4D8);
      case LessonStatus.completed:
        return AppColors.primary;
      case LessonStatus.locked:
        return context.surfaceContainer.withOpacity(0.5);
    }
  }

  String get buttonText {
    switch (this) {
      case LessonStatus.completed:
        return 'مراجعة الدرس';
      case LessonStatus.inProgress:
        return 'استمرار التعلم';
      case LessonStatus.notStarted:
        return 'بدء التعلم';
      case LessonStatus.locked:
        return 'مغلق';
    }
  }

  // أيقونة الزر
  IconData get buttonIcon {
    switch (this) {
      case LessonStatus.completed:
        return Icons.refresh;
      case LessonStatus.inProgress:
        return Icons.play_arrow;
      case LessonStatus.notStarted:
        return Icons.play_arrow_outlined;
      case LessonStatus.locked:
        return Icons.lock_outline;
    }
  }

  IconData get timeLineIcons {
    switch (this) {
      case LessonStatus.locked:
        return Icons.lock_outline;
      case LessonStatus.notStarted:
        return Icons.play_circle_outline;
      case LessonStatus.inProgress:
        return Icons.play_circle_filled;
      case LessonStatus.completed:
        return Icons.check_circle;
    }
  }
}
