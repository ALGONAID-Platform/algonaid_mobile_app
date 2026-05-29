import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/linearProgress.dart';
import 'package:flutter/material.dart';

class CourseProgressInfo extends StatelessWidget {
  final int completedCount; // نمرر العدد بدلاً من النص الجاهز
  final int totalCount;
  final double progress;
  final VoidCallback? onContinueTap;
  final List<Color> colors;

  const CourseProgressInfo({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    this.onContinueTap,
    this.colors = const [AppColors.primary, AppColors.primaryLight],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16), // مسافة بسيطة من الأسفل
      decoration: BoxDecoration(
        color: context.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مكتمل $completedCount من أصل $totalCount درس",
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${(progress).toInt()}% من المنهج",
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: onContinueTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
                child: Row(
                  children: [
                    Text("واصل التعلم", style: context.textTheme.labelMedium),
                    SizedBox(width: 4),
                    Icon(Icons.play_arrow_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), 
          LinearProgress(progressPercentage: progress),
        ],
      ),
    );
  }
}
