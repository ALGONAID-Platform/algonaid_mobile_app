import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:algonaid_mobail_app/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow:AppShadows.cardShadow
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // حل مشكلة التمدد الطولي: يأخذ حجم محتواه فقط
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 160, // يمكنك تعديل الارتفاع حسب الرغبة
                child: _CourseImagePreview(),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CourseMetaTags(),
                    const SizedBox(height: 12),
                    Text(
                      'الاشتقاق - تفاضل وتكامل',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'تعلم أساسيات الاشتقاق وقواعده الأساسية بشكل مبسط.',
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    const _ProgressBarSection(),
                    const SizedBox(height: 16),
                    const _ActionButtonsRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseMetaTags extends StatelessWidget {
  const _CourseMetaTags();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'رياضيات',
            style: Styles.style12(context).copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.access_time, size: 14, color: theme.hintColor),
        const SizedBox(width: 4),
        Text('٤٥ د', style: Styles.style12(context)),
      ],
    );
  }
}

class _ProgressBarSection extends StatelessWidget {
  const _ProgressBarSection();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: 0.46,

          backgroundColor: Colors.grey[300],
          color: theme.colorScheme.primary,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 6),
        Text(
          '١٤ درس مكتمل من أصل ٢٠ درساً',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // زر استمرار - استخدمنا Expanded ليتساوى مع الزر الآخر
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              // أزلنا العرض الثابت هنا لأن Expanded سيتولى الأمر
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'استمرار',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),

        const SizedBox(width: 12), // مسافة أكبر قليلاً لمظهر أنظف
        // زر التفاصيل - باهت ومتساوي في الحجم
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              // حدود باهتة جداً
              side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'التفاصيل',
              style: TextStyle(
                // نص باهت باستخدام الشفافية
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseImagePreview extends StatelessWidget {
  const _CourseImagePreview();
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          Images.onboarding1,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          ),
        ),
        // طبقة تظليل خفيفة ليظهر زر التشغيل بوضوح
        Container(color: Colors.black12),
        const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 45),
        ),
      ],
    );
  }
}
