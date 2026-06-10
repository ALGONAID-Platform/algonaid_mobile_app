import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textStyle,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor ?? context.primary.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? context.primary, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: textStyle ?? context.bodySmall?.copyWith(height: 1.5, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
