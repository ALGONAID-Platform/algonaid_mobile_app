import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonPdfCard extends StatelessWidget {
  final String? pdfUrl;
  final VoidCallback onOpen;

  const LessonPdfCard({
    super.key,
    required this.pdfUrl,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfUrl != null && pdfUrl!.isNotEmpty;

    return InkWell(
      onTap: hasPdf ? onOpen : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.25),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.indigo,
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
              color: hasPdf ? AppColors.primary : AppColors.grey300,
            ),
          ],
        ),
      ),
    );
  }
}
