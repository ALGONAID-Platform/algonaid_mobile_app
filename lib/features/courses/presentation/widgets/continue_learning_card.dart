import 'package:algonaid_mobail_app/core/constants/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Theme.of(context) لجلب الألوان تلقائياً
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          // التبديل التلقائي بين لون السطح في الفاتح والمظلم
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _CourseMetaTags(),
                        const SizedBox(height: 10),
                        Text(
                          'الاشتقاق - تفاضل وتكامل',
                          // استخدام ستايل العناوين من الثيم
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تعلم أساسيات الاشتقاق وقواعده الأساسية بشكل مبسط.',
                          // استخدام ستايل الجسم الصغير من الثيم
                          style: theme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        const _ProgressBarSection(),
                        const SizedBox(height: 16),
                        const _ActionButtonsRow(),
                      ],
                    ),
                  ),
                ),
                const _CourseImagePreview(),
              ],
            ),
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
        Icon(Icons.access_time, size: 12, color: theme.hintColor),
        const SizedBox(width: 2),
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
          backgroundColor: theme.colorScheme.surfaceVariant,
          color: theme.colorScheme.primary,
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 4),
        Text(
          '١٤ درس مكتمل من أصل ٢٠ درساً',
          style: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 0,
            minimumSize: const Size(80, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: const Text('استمرار', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            // استخدام لون الإطار من الثيم
            side: BorderSide(color: theme.dividerColor),
            minimumSize: const Size(80, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: Text(
            'التفاصيل',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
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
    return Expanded(
      flex: 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Images.noImageFound, fit: BoxFit.cover),
          Container(color: Colors.black26),
          const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
