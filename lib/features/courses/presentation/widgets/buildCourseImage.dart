import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuildCourseImage extends StatelessWidget {
  const BuildCourseImage({super.key, required this.course});

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    // جلب الثيم الحالي
    final theme = Theme.of(context);

    return Stack(
      children: [
        // 1. الصورة مع Placeholder معتمد على الثيم
        ClipRRect(
          // نستخدم الـ Clip هنا للتأكد من أن الصورة لا تخرج عن حواف الكارت الدائرية
          child: CachedNetworkImage(
            imageUrl: course.thumbnail,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            // نستخدم لون الـ surface المتغير بدلاً من لون ثابت
            placeholder: (context, url) => Container(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
            errorWidget: (context, url, error) => Container(
              color: theme.colorScheme.errorContainer,
              child: Image.asset(Images.noImageFound, fit: BoxFit.cover),
            ),
          ),
        ),

        // 2. طبقة الظل المتدرج (Gradient Overlay)
        // ملاحظة: نبقي الألوان هنا داكنة لأن النص أبيض دائماً فوق الصور
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(
                    0.7,
                  ), // تقليل الشفافية قليلاً لجمالية أكثر
                ],
              ),
            ),
          ),
        ),

        // 3. عنوان الكورس
        Positioned(
          bottom: 16,
          right: 16,
          
          child: Text(
           
            course.title,
            // نستخدم ستايل العناوين من الثيم مباشرة
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white, // النص يبقى أبيض فوق الظل الداكن دائماً
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            softWrap: false,

            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
