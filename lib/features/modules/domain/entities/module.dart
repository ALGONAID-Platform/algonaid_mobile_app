// algonaid_mobail_app/lib/features/modules/domain/entities/module.dart

import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:equatable/equatable.dart';

class Module extends Equatable {
  final int id;
  final String title;
  final String description;
  final int courseId;
  final List<Lesson> lessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalLessons;

  const Module({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.lessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalLessons,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    courseId,
    lessons,
    completedLessons,
    progressPercentage,
    totalLessons,
  ];
}
