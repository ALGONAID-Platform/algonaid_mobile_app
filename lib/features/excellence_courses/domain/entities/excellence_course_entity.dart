import 'package:equatable/equatable.dart';

class ExcellenceCourseEntity extends Equatable {
  final int courseId;
  final String courseTitle;
  final String courseImage;
  final num averagePercentage;
  final DateTime? completedAt;
  final bool isCompleted;
  final num? targetAverage;
  final bool? allExamsAttempted;

  const ExcellenceCourseEntity({
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
    required this.averagePercentage,
    required this.completedAt,
    required this.isCompleted,
    this.targetAverage,
    this.allExamsAttempted,
  });

  @override
  List<Object?> get props => [
        courseId,
        courseTitle,
        courseImage,
        averagePercentage,
        completedAt,
        isCompleted,
        targetAverage,
        allExamsAttempted,
      ];
}
