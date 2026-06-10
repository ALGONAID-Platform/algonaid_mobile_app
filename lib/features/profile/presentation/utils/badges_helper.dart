import 'package:algonaid_mobile_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_badge_entity.dart';

class BadgeEntity {
  final int id;
  final String key;
  final String title;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final String requirementText;
  final int progress;
  final int target;
  final String tier;

  BadgeEntity({
    required this.id,
    required this.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.requirementText,
    required this.progress,
    required this.target,
    required this.tier,
  });
}

class BadgesHelper {
  static final _badgeMeta = {
    'starter': {
      'title': 'وسام البداية',
      'icon': Icons.flag_circle_rounded,
      'color': Colors.blue,
      'requirementText': 'يُمنح عند إنهاء أول درس لك في المنصة.',
    },
    'persistence': {
      'title': 'وسام المواظبة',
      'icon': Icons.calendar_month_rounded,
      'color': Colors.orange,
      'requirementText': 'يُمنح عند الاستمرار بالدراسة لمدة 3 أيام متتالية.',
    },
    'continuous': {
      'title': 'وسام المستمر',
      'icon': Icons.loop_rounded,
      'color': Colors.green,
      'requirementText': 'يُمنح عند الدراسة لـ 7 أيام متواصلة بدون انقطاع.',
    },
    'explorer': {
      'title': 'وسام المستكشف',
      'icon': Icons.explore_rounded,
      'color': AppColors.primary,
      'requirementText': 'يُمنح عند مشاهدة 20 درساً كاملاً.',
    },
    'nerd': {
      'title': 'وسام الدافور',
      'icon': Icons.menu_book_rounded,
      'color': AppColors.red,
      'requirementText': 'يُمنح عند إكمال كورسين (2) متكاملين.',
    },
    'terrifying_brain': {
      'title': 'وسام المخ المرعب',
      'icon': Icons.psychology_rounded,
      'color': Colors.purple,
      'requirementText': 'يُمنح عند إكمال 4 كورسات متكاملة.',
    },
    'elite': {
      'title': 'وسام النخبة',
      'icon': Icons.military_tech_rounded,
      'color': AppColors.amber,
      'requirementText': 'يُمنح عند إكمال كل الكورسات المتاحة في المنصة.',
    },
    'marathon': {
      'title': 'وسام الماراثون',
      'icon': Icons.directions_run_rounded,
      'color': Colors.redAccent,
      'requirementText': 'يُمنح عند إنهاء 10 دروس في يوم واحد.',
    },
    'night_owl': {
      'title': 'وسام بومة الليل',
      'icon': Icons.nights_stay_rounded,
      'color': Colors.indigo,
      'requirementText': 'يُمنح عند مشاهدة الدروس بعد منتصف الليل لمدة 5 أيام.',
    },
    'early_bird': {
      'title': 'وسام عصفور الصباح',
      'icon': Icons.wb_sunny_rounded,
      'color': Colors.orangeAccent,
      'requirementText':
          'يُمنح للطلاب الذين يكملون الدروس بين الساعة 5 صباحاً و 9 صباحاً.',
    },
    'reviewer': {
      'title': 'وسام المُراجع الدقيق',
      'icon': Icons.replay_rounded,
      'color': Colors.teal,
      'requirementText': 'يُمنح عند إعادة مشاهدة درس للمرة الثانية.',
    },
  };

  static List<BadgeEntity> getBadges(List<UserBadgeEntity> userBadges) {
    if (userBadges.isEmpty) {
      return _badgeMeta.entries.map((e) {
        return BadgeEntity(
          id: 0,
          key: e.key,
          title: e.value['title'] as String,
          icon: e.value['icon'] as IconData,
          color: e.value['color'] as Color,
          isUnlocked: false,
          requirementText: e.value['requirementText'] as String,
          progress: 0,
          target: 1,
          tier: 'STANDARD',
        );
      }).toList();
    }
    return userBadges.map((badge) {
      final meta =
          _badgeMeta[badge.key] ??
          {
            'title': 'وسام غير معروف',
            'icon': Icons.star,
            'color': Colors.grey,
            'requirementText': '',
          };
      return BadgeEntity(
        id: badge.id,
        key: badge.key,
        title: meta['title'] as String,
        icon: meta['icon'] as IconData,
        color: meta['color'] as Color,
        isUnlocked: badge.isUnlocked,
        requirementText: meta['requirementText'] as String,
        progress: badge.progress,
        target: badge.target,
        tier: badge.tier,
      );
    }).toList();
  }
}
