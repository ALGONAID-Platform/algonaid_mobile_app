import 'package:equatable/equatable.dart';

class CourseProgressEntity extends Equatable {
  final int courseId;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;

  const CourseProgressEntity({
    required this.courseId,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
  });

  @override
  List<Object?> get props => [courseId, totalLessons, completedLessons, progressPercentage];
}