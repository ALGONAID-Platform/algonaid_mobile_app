import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String text;
  final String? subText;
  final VoidCallback? onViewAllPressed;
  final IconData? icon;
  final Color? iconColor;

  const SectionHeader({
    super.key, 
    required this.text, 
    this.subText,
    this.onViewAllPressed,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: iconColor ?? context.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(text, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                if (subText != null) ...[
                  const SizedBox(width: 6),
                  Text('($subText)', style: context.textTheme.labelMedium?.copyWith(color: Colors.grey)),
                ],
              ],
            ),
            if (onViewAllPressed != null)
              TextButton(
                onPressed: onViewAllPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('عرض الكل', style: context.textTheme.bodyMedium?.copyWith(color: context.primary)),
              ),
          ],
        ),
      ),
    );
  }
}
