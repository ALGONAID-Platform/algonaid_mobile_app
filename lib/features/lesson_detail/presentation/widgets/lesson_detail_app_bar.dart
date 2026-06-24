import 'package:flutter/material.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';

class LessonDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;

  const LessonDetailAppBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SharedAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: onBack,
      ),
      titleWidget: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, size: 20),
          onPressed: onShare,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
