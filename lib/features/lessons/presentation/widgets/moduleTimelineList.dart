import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonTimelineItem extends StatelessWidget {
  final dynamic lesson; // هنا نمرر كائن الدرس القادم من قاعدة البيانات
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
    final isDark = theme.brightness == Brightness.dark;

    // --- منطق استخراج الحالة من قاعدة البيانات ---
    // افترضت هنا مسميات الحقول، قم بتغييرها حسب الـ Model الخاص بك
    final bool isCompleted = true;
    final bool isLocked = false;
    final bool isCurrent = true;
    final bool isOptional = false;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntrinsicHeight(
        // لضمان تمدد الخط الجانبي مع طول الكارد
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الجزء الجانبي (Timeline)
            _buildTimelineIndicator(isDark, isCompleted, isCurrent, isLocked),

            const SizedBox(width: 16),

            // 2. الكارد الرئيسي
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ), // مسافة بين الكاردات
                child: InkWell(
                  onTap: isLocked ? null : onTap, // تعطيل الضغط إذا كان مقفلاً
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isLocked
                            ? (isDark ? Colors.white10 : Colors.grey.shade100)
                            : (isDark
                                  ? AppColors.indigoDark
                                  : AppColors.grey200),
                      ),
                      boxShadow: [
                        if (!isLocked)
                          BoxShadow(
                            color: isDark ? Colors.black26 : AppColors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Opacity(
                      opacity: isLocked ? 0.6 : 1.0, // تقليل الوضوح للمقفل
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  lesson.title ?? 'بدون عنوان',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isCompleted)
                                _buildStatusTag('مكتمل', AppColors.green),
                              if (isCurrent)
                                _buildStatusTag('قيد التعلم', Colors.blue),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildActionButton(
                            isCompleted,
                            isCurrent,
                            isLocked,
                            isOptional,
                            isDark,
                          ),
                        ],
                      ),
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

  // بناء الخط والأيقونة الجانبية
  Widget _buildTimelineIndicator(
    bool isDark,
    bool completed,
    bool current,
    bool locked,
  ) {
    Color color = locked ? AppColors.grey300 : AppColors.green;
    IconData icon = locked
        ? Icons.lock_outline
        : (completed ? Icons.check_circle : Icons.play_circle_filled);

    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: locked
                  ? AppColors.grey200
                  : AppColors.green.withOpacity(0.5),
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

  Widget _buildActionButton(
    bool completed,
    bool current,
    bool locked,
    bool optional,
    bool isDark,
  ) {
    if (completed) {
      return _customButton(
        'مراجعة الدرس',
        AppColors.green,
        isOutlined: true,
        icon: Icons.refresh,
      );
    } else if (current) {
      return _customButton(
        'استمرار التعلم',
        Colors.blue,
        isOutlined: false,
        icon: Icons.play_arrow,
      );
    } else if (optional) {
      return Text(
        'اختياري',
        style: TextStyle(color: AppColors.grey400, fontSize: 12),
        textAlign: TextAlign.left,
      );
    }
    return const SizedBox.shrink();
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
              color: isOutlined ? color : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
