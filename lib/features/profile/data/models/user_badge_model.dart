import 'package:algonaid_mobail_app/features/profile/domain/entities/user_badge_entity.dart';


class UserBadgeModel extends UserBadgeEntity {
  UserBadgeModel({
    required super.id,
    required super.key,
    required super.isUnlocked,
    required super.progress,
    required super.target,
    required super.tier,
  });

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) {
    return UserBadgeModel(
      id: json['id'] as int,
      key: json['key'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      progress: json['progress'] as int,
      target: json['target'] as int,
      tier: json['tier'] as String? ?? 'STANDARD',
    );
  }
}
