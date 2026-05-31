import 'package:flutter/material.dart';

class DeveloperInfo {
  final String name;
  final String githubUrl;
  final String linkedinUrl;
  final String imagePath;
  final IconData avatarIcon;
  final Color themeColor;

  const DeveloperInfo({
    required this.name,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.imagePath,
    required this.avatarIcon,
    required this.themeColor,
  });
}
