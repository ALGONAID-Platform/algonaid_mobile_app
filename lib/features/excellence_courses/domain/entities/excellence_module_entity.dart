import 'package:equatable/equatable.dart';

class ExcellenceModuleEntity extends Equatable {
  final int moduleId;
  final String moduleTitle;
  final int courseId;
  final String courseTitle;
  final num averagePercentage;
  final bool isCompleted;

  const ExcellenceModuleEntity({
    required this.moduleId,
    required this.moduleTitle,
    required this.courseId,
    required this.courseTitle,
    required this.averagePercentage,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
        moduleId,
        moduleTitle,
        courseId,
        courseTitle,
        averagePercentage,
        isCompleted,
      ];
}
