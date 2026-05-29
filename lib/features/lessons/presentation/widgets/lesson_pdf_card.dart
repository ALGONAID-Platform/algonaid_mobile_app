import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/borders.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/features/lessons/presentation/controllers/lesson_detail_download_controller.dart';
import 'package:flutter/material.dart';

class LessonPdfCard extends StatelessWidget {
  final String? pdfUrl;
  final VoidCallback onOpen;
  final DownloadStatus downloadStatus;
  final int downloadProgress;
  final VoidCallback onDownload;

  const LessonPdfCard({
    super.key, 
    required this.pdfUrl, 
    required this.onOpen,
    required this.downloadStatus,
    required this.downloadProgress,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
         border: AppBorder.main_border
          // دمج الحواف الديناميكية للوضع الداكن/الفاتح
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(isDark ? 0.20 : 0.12),
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
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasPdf ? 'عرض ملف PDF' : 'لا يوجد ملف مرفق',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            if (hasPdf)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (downloadStatus == DownloadStatus.downloading)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: downloadProgress > 0 ? downloadProgress / 100 : null,
                        strokeWidth: 2.5,
                        color: context.primary,
                      ),
                    )
                   
                  else if (downloadStatus == DownloadStatus.downloaded)
                    Icon(Icons.check_circle_rounded, color: context.primary),
                    
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: context.primary,
                  ),
                ],
              )
            else
              Icon(
                Icons.chevron_left,
                color: theme.colorScheme.onSurface.withOpacity(0.35),
              ),
          ],
        ),
      ),
    );
  }
}