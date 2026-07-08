import 'dart:ui';
import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/shared_app_bar.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:algonaid_mobile_app/features/profile/presentation/utils/badges_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/app_bottom_sheet.dart';
import 'package:algonaid_mobile_app/core/widgets/shared/info_banner.dart';

class AllBadgesPage extends StatelessWidget {
  const AllBadgesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
        appBar: SharedAppBar(
          title: 'جميع الأوسمة',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            final allBadges = BadgesHelper.getBadges(provider.userBadges);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InfoBanner(
                      message:
                          'هذه الأوسمة خاصة بمشاهدة الدروس، يتم حسابها بناءً على الدروس التي تمت مشاهدتها وليس لها علاقة بالاختبارات.',
                      padding: const EdgeInsets.all(16.0),
                      textStyle: context.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: allBadges.length,
                      itemBuilder: (context, index) {
                        final badge = allBadges[index];
                        return _BadgeCard(badge: badge);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeEntity badge;

  const _BadgeCard({Key? key, required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        color: badge.isUnlocked ? badge.color : Colors.grey,
                        size: 40,
                      ),
                    ),
                    if (badge.isUnlocked && badge.tier != 'STANDARD')
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            badge.tier == 'PRO_MAX' ? 'محترف' : 'متقدم',
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
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  badge.requirementText,
                  style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                // ── تاريخ الاكتساب (يظهر فقط للأوسمة المفتوحة) ──
                if (badge.isUnlocked && badge.earnedAt != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: badge.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: badge.color.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_rounded,
                          color: badge.color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'حصلت عليه في ${BadgesHelper.formatEarnedDate(badge.earnedAt!)}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: badge.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // ── إشعار "إضافة محتوى جديد" ──
                if (badge.isUnlocked && badge.progress < badge.target) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'تمت إضافة محتوى جديد! أكمل ${badge.target - badge.progress} إضافية للحفاظ على إنجازك بنسبة 100%.',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: Colors.orange[800],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                          style: context.textTheme.labelMedium?.copyWith(
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
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badge.isUnlocked
                          ? badge.color.withOpacity(0.12)
                          : Colors.grey.withOpacity(0.1),
                      boxShadow: badge.isUnlocked
                          ? [
                              BoxShadow(
                                color: badge.color.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  Icon(
                    badge.isUnlocked ? badge.icon : Icons.lock_outline_rounded,
                    color: badge.isUnlocked ? badge.color : Colors.grey,
                    size: 32,
                  ),
                  if (badge.isUnlocked && badge.tier != 'STANDARD')
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badge.tier == 'PRO_MAX'
                              ? Colors.amber
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          badge.tier == 'PRO_MAX' ? 'محترف' : 'متقدم',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  badge.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badge.isUnlocked
                        ? context.colorScheme.onSurface
                        : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // ── عرض "مكتسب ✓" مع تاريخ مختصر في بطاقة الشبكة ──
              if (badge.isUnlocked && badge.earnedAt != null) ...[
                const SizedBox(height: 4),
                if (badge.progress < badge.target)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 12, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'محتوى جديد',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badge.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '✓ ${badge.earnedAt!.year}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badge.color,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
