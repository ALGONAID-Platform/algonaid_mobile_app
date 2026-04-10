import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

class BuildCourseDetails extends StatelessWidget {
  const BuildCourseDetails({
    super.key,
    required this.tags,
    this.modulesCount = 0,
    this.isEnrolled = false,
    this.progress = 0.1,
    this.completedModules = 1,
  });

  final List<String> tags;
  final int modulesCount;
  final bool isEnrolled;
  final double progress;
  final int completedModules;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      // استخدمنا LayoutBuilder كخيار إضافي إذا أردت مستقبلاً التحكم في المحتوى بناءً على المساحة
      child: Column(
        // 🌟 أهم نقطة: التوزيع لضمان استقرار الزر في الأسفل
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. الجزء العلوي (العناوين والتاغات)
          _buildHeaderSection(context, colorScheme),

          // 2. الجزء الأوسط (التقدم) - يظهر فقط إذا كان المستخدم مسجلاً
          if (isEnrolled) _buildProgressSection(context, colorScheme),

          // 3. الجزء السفلي (الزر)
          _buildActionButton(colorScheme),
        ],
      ),
    );
  }

  // --- ودجت فرعي للهيدر ---
  Widget _buildHeaderSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          " وحدات تعليمية متاحة $modulesCount",
          style: Styles.style14(context).copyWith(
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (tags.isNotEmpty && isEnrolled == false) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 35,
            child: ClipRect(
              child: Wrap(
                spacing: 8,
                children: tags.map((tag) => _CourseTag(label: tag)).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // --- ودجت فرعي للبروجريس ---
  Widget _buildProgressSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${(progress * 100).toInt()}%",
              style: Styles.style12(context).copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              "$completedModules / $modulesCount مكتمل", // تم تعديل الترتيب ليكون منطقياً
              style: Styles.style12(context).copyWith(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Directionality(
            textDirection:
                TextDirection.rtl, // لجعل التقدم يتجه من اليمين لليسار
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  // --- ودجت فرعي للزر ---
  Widget _buildActionButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: isEnrolled
          ? TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: AppColors.green.withOpacity(0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: AppColors.primary,
              ),
              child: const Text(
                "استمرار",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : ElevatedButton(
              onPressed: () {},
              child: const Text("استكشف الدورة الآن"),
            ),
    );
  }
}

// فصل الـ Tag في Class مستقل واستخدام الـ Theme داخله
class _CourseTag extends StatelessWidget {
  final String label;
  const _CourseTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceVariant.withOpacity(0.5) ??
            theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: Styles.style12(context).copyWith(
          color: theme
              .colorScheme
              .onSurface, // لون النص التلقائي المتوافق مع الخلفية
        ),
      ),
    );
  }
}
