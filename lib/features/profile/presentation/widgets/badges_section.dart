import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badges = [
      {'title': 'مبتدئ', 'icon': Icons.star_border, 'color': AppColors.amber},
      {
        'title': 'متعلم نشط',
        'icon': Icons.local_fire_department,
        'color': AppColors.red,
      },
      {'title': 'مكتشف', 'icon': Icons.explore, 'color': AppColors.primary},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SectionHeader(text: 'أوسمة التميز'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: badges.map((badge) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (badge['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      badge['icon'] as IconData,
                      color: badge['color'] as Color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    badge['title'] as String,
                    style: context.textTheme.labelMedium,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
