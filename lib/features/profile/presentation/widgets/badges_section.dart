import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/section_header.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/utils/badges_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final allBadges = BadgesHelper.getBadges(provider.userBadges);
        // Show only the first 4 badges in the section
        final displayBadges = allBadges.take(4).toList();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  text: 'أوسمة التميز',
                  subText: 'خاص بمشاهدة الدروس',
                  iconColor: context.primary,
                  onViewAllPressed: () {
                    context.push(Routes.allBadgesPage);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: displayBadges.map((badge) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          AppBottomSheet.show(
                            context: context,
                            title: badge.title,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: badge.isUnlocked
                                              ? badge.color.withOpacity(0.12)
                                              : Colors.grey.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          badge.isUnlocked
                                              ? badge.icon
                                              : Icons.lock_outline_rounded,
                                          color: badge.isUnlocked
                                              ? badge.color
                                              : Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                      if (badge.isUnlocked &&
                                          badge.tier != 'STANDARD')
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: badge.tier == 'PRO_MAX'
                                                  ? Colors.amber
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: Text(
                                              badge.tier == 'PRO_MAX'
                                                  ? 'محترف'
                                                  : 'متقدم',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    badge.title,
                                    style: context.textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    badge.requirementText,
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (!badge.isUnlocked) ...[
                                    const SizedBox(height: 24),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'هذا الوسام غير مفتوح بعد',
                                            style: context.textTheme.labelMedium
                                                ?.copyWith(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainer
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: badge.isUnlocked
                                  ? badge.color.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: badge.isUnlocked
                                ? [
                                    BoxShadow(
                                      color: badge.color.withOpacity(0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Opacity(
                            opacity: badge.isUnlocked ? 1.0 : 0.4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: badge.isUnlocked
                                            ? badge.color.withOpacity(0.12)
                                            : Colors.grey.withOpacity(0.1),
                                        boxShadow: badge.isUnlocked
                                            ? [
                                                BoxShadow(
                                                  color: badge.color
                                                      .withOpacity(0.2),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                    Icon(
                                      badge.isUnlocked
                                          ? badge.icon
                                          : Icons.lock_outline_rounded,
                                      color: badge.isUnlocked
                                          ? badge.color
                                          : Colors.grey,
                                      size: 24,
                                    ),
                                    if (badge.isUnlocked &&
                                        badge.tier != 'STANDARD')
                                      Positioned(
                                        bottom: -2,
                                        right: -2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: badge.tier == 'PRO_MAX'
                                                ? Colors.amber
                                                : Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            badge.tier == 'PRO_MAX'
                                                ? 'محترف'
                                                : 'متقدم',
                                            style: const TextStyle(
                                              fontSize: 6,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  badge.title,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: badge.isUnlocked
                                        ? context.colorScheme.onSurface
                                        : Colors.grey,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
