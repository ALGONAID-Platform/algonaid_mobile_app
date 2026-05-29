import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.totalLessons});

  final int totalLessons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SectionHeader(text: "مسار التعلم"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Text(
              "${totalLessons}  دروس",
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
