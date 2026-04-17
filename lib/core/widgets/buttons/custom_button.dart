import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final ShapeBorder? shape;
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.color,
    required this.textColor,
    this.shape,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: 80,

      elevation: 0,
      padding: const EdgeInsets.all(10),
      color: color,
      textColor: textColor,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      onPressed: onPressed,
      child: Text(text, style: Styles.style16(context)),
    );
  }
}
