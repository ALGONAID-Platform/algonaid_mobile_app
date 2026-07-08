import 'dart:ui';
import 'package:hive/hive.dart';

import 'package:algonaid_mobile_app/core/common/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

part 'lesson_status.g.dart';

@HiveType(typeId: 20)
enum LessonStatus {
  @HiveField(0)
  notStarted,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  locked
}
