import 'package:equatable/equatable.dart';

class LastAccessedModuleEntity extends Equatable {
  final int moduleId;
  final String courseName;
  final String moduleName;
  final String moduleDescription;
  final int totalLessons;
  final int completedLessons;
  final num progressPercentage;
  final String image_url;

  const LastAccessedModuleEntity({
    required this.moduleId,
    required this.courseName,
    required this.moduleName,
    required this.moduleDescription,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.image_url,

  });

  @override
  List<Object?> get props => [
    moduleId,
    courseName,
    moduleName,
    moduleDescription,
    totalLessons,
    completedLessons,
    progressPercentage,
    image_url
  ];
}
