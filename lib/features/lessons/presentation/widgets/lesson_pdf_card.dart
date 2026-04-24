import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonPdfCard extends StatelessWidget {
  final String? pdfUrl;
  final VoidCallback onOpen;

  const LessonPdfCard({super.key, required this.pdfUrl, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasPdf = pdfUrl != null && pdfUrl!.isNotEmpty;

    return InkWell(
      onTap: hasPdf ? onOpen : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.primary.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص الدرس',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasPdf ? 'عرض ملف PDF' : 'لا يوجد ملف مرفق',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: hasPdf
                  ? AppColors.primary
                  : theme.colorScheme.onSurface.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}
