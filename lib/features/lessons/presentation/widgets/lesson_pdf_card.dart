import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonPdfCard extends StatelessWidget {
  final String? pdfUrl;
  final VoidCallback onOpen;

  const LessonPdfCard({super.key, required this.pdfUrl, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfUrl != null && pdfUrl!.isNotEmpty;

    return InkWell(
      onTap: hasPdf ? onOpen : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.primary.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.picture_as_pdf,
                color: context.primary,
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
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasPdf ? 'عرض ملف PDF' : 'لا يوجد ملف مرفق',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: hasPdf ? context.primary : AppColors.grey300,
            ),
          ],
        ),
      ),
    );
  }
}
