import 'package:flutter/material.dart';

class SettingsIconWrapper extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SettingsIconWrapper({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 24, color: color),
    );
  }
}
