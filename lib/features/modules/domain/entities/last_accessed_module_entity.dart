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

  LastAccessedModuleEntity copyWith({
    int? moduleId,
    String? courseName,
    String? moduleName,
    String? moduleDescription,
    int? totalLessons,
    int? completedLessons,
    num? progressPercentage,
    String? image_url,
  }) {
    return LastAccessedModuleEntity(
      moduleId: moduleId ?? this.moduleId,
      courseName: courseName ?? this.courseName,
      moduleName: moduleName ?? this.moduleName,
      moduleDescription: moduleDescription ?? this.moduleDescription,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      image_url: image_url ?? this.image_url,
    );
  }

  @override
  List<Object?> get props => [
        moduleId,
        courseName,
        moduleName,
        moduleDescription,
        totalLessons,
        completedLessons,
        progressPercentage,
        image_url,
      ];
}
