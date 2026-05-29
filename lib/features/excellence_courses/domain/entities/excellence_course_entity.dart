import 'package:equatable/equatable.dart';

class ExcellenceCourseEntity extends Equatable {
  final int courseId;
  final String courseTitle;
  final String courseImage;
  final num averagePercentage;
  final DateTime completedAt;
  final bool isCompleted;

  const ExcellenceCourseEntity({
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
    required this.averagePercentage,
    required this.completedAt,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        courseId,
        courseTitle,
        courseImage,
        averagePercentage,
        completedAt,
        isCompleted,
      ];
}
