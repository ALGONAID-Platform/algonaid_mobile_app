import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonDetailBottomBar extends StatelessWidget {
  final VoidCallback? onNextLessonPressed; // Null means no next lesson
  final VoidCallback? onPreviousLessonPressed; // Null means no previous lesson

  const LessonDetailBottomBar({
    super.key,
    this.onNextLessonPressed,
    this.onPreviousLessonPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (onNextLessonPressed == null && onPreviousLessonPressed == null) {
      return const SizedBox.shrink();
    }
    
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: context.background,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (onNextLessonPressed != null)
              Expanded(
                child: ElevatedButton(
                  onPressed: onNextLessonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'الدرس التالي',
                        style: context.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (onNextLessonPressed != null && onPreviousLessonPressed != null)
              const SizedBox(width: 12),
            if (onPreviousLessonPressed != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: onPreviousLessonPressed,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: context.colorScheme.onSecondary.withOpacity(0.5),
                    ),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الدرس السابق',
                        style: context.textTheme.labelLarge!.copyWith(
                          color: context.colorScheme.onSecondary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: context.colorScheme.onSecondary.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
