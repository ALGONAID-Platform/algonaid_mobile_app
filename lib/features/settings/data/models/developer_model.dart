import 'package:algonaid_mobail_app/features/settings/domain/entities/developer_info.dart';
import 'package:flutter/material.dart';

class DeveloperModel extends DeveloperInfo {
  const DeveloperModel({
    required String name,
    required String githubUrl,
    required String linkedinUrl,
    required String imagePath,
    required IconData avatarIcon,
    required Color themeColor,
  }) : super(
          name: name,
          githubUrl: githubUrl,
          linkedinUrl: linkedinUrl,
          imagePath: imagePath,
          avatarIcon: avatarIcon,
          themeColor: themeColor,
        );

  factory DeveloperModel.fromEntity(DeveloperInfo entity) {
    return DeveloperModel(
      name: entity.name,
      githubUrl: entity.githubUrl,
      linkedinUrl: entity.linkedinUrl,
      imagePath: entity.imagePath,
      avatarIcon: entity.avatarIcon,
      themeColor: entity.themeColor,
    );
  }
}
