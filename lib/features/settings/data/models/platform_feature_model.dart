import 'package:algonaid_mobail_app/features/settings/domain/entities/platform_feature.dart';
import 'package:flutter/material.dart';

class PlatformFeatureModel extends PlatformFeature {
  const PlatformFeatureModel({
    required IconData icon,
    required String title,
  }) : super(
          icon: icon,
          title: title,
        );

  factory PlatformFeatureModel.fromEntity(PlatformFeature entity) {
    return PlatformFeatureModel(
      icon: entity.icon,
      title: entity.title,
    );
  }
}
