import 'package:algonaid_mobail_app/core/theme/colors.dart';
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
      // تقليل الحشوة الداخلية لجعل الصندوق أنحف
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16), // مسافة بسيطة من الأسفل
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لجعل العمود يأخذ أقل مساحة ممكنة
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // النصوص: "مكتمل 10 من أصل 20"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "مكتمل $completedCount من أصل $totalCount درس",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // صغرنا الخط قليلاً للتناسب
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${(progress * 100).toInt()}% من المنهج",
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),

              // زر واصل التعلم بحجم مضغوط
              ElevatedButton(
                onPressed: onContinueTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(
                    0,
                    36,
                  ), // تحديد حد أدنى للارتفاع ليكون أنحف
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      "واصل التعلم",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.play_arrow_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // مسافة بسيطة قبل الشريط
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
