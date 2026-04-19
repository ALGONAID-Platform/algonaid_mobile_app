import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart'; // Import PathsRoutes
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart'; // Import CourseEntity

class BuildCourseDetails extends StatelessWidget {
  const BuildCourseDetails({
    super.key,
    required this.course, // Add CourseEntity
    required this.tags,
    this.modulesCount = 0,
    this.isEnrolled = false,
    this.progress = 0.1,
    this.completedModules = 1,
  });

  final CourseEntity course; // Declare CourseEntity
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
          _buildActionButton(context, colorScheme), // Pass context
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
                // children: tags.map((tag) => _CourseTag(label: tag)).toList(),
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
  Widget _buildActionButton(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: isEnrolled
          ? TextButton(
              onPressed: () {
                debugPrint('Navigating to Modules List for course: ${course.id}');
                GoRouter.of(context).go('${Routes.modulesList}/${course.id}', extra: course.title);
              },
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
              onPressed: () {
                debugPrint('Navigating to Modules List for course: ${course.id}');
                GoRouter.of(context).go('${Routes.modulesList}/${course.id}', extra: course.title);
              },
              child: const Text("استكشف الدورة الآن"),
            ),
    );
  }
}
