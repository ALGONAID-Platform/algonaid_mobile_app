import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class LessonDetailBottomBar extends StatelessWidget {
  final VoidCallback onLessonsListPressed;
  final VoidCallback? onDownloadPressed;
  final String downloadLabel;
  final bool isDownloaded;

  const LessonDetailBottomBar({
    super.key,
    required this.onLessonsListPressed,
    required this.onDownloadPressed,
    required this.downloadLabel,
    required this.isDownloaded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onLessonsListPressed,
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('قائمة الدروس'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onDownloadPressed,
                icon: Icon(
                  isDownloaded
                      ? Icons.check_circle_outline
                      : Icons.download_rounded,
                ),
                label: Text(downloadLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
