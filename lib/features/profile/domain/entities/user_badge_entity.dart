class UserBadgeEntity {
  final int id;
  final String key;
  final bool isUnlocked;
  final int progress;
  final int target;
  final String tier;
  /// تاريخ اكتساب الوسام — لا يكون null إلا إذا لم يُكتسب بعد
  final DateTime? earnedAt;

  UserBadgeEntity({
    required this.id,
    required this.key,
    required this.isUnlocked,
    required this.progress,
    required this.target,
    required this.tier,
    this.earnedAt,
  });
}
