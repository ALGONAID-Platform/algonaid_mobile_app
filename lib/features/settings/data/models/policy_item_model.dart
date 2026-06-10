import 'package:algonaid_mobile_app/features/settings/domain/entities/policy_item.dart';

class PolicyItemModel extends PolicyItem {
  const PolicyItemModel({required String title, required String content})
    : super(title: title, content: content);

  factory PolicyItemModel.fromEntity(PolicyItem entity) {
    return PolicyItemModel(title: entity.title, content: entity.content);
  }
}
