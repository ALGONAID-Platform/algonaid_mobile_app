import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';

class LastAccessedModuleModel extends LastAccessedModuleEntity {
  const LastAccessedModuleModel({
    required int moduleId,
    required String courseName,
    required String moduleName,
    required String moduleDescription,
    required int totalLessons,
    required int completedLessons,
    required num progressPercentage,
        required String image_url,

  }) : super(
          moduleId: moduleId,
          courseName: courseName,
          moduleName: moduleName,
          moduleDescription: moduleDescription,
          totalLessons: totalLessons,
          completedLessons: completedLessons,
          progressPercentage: progressPercentage,
          image_url: image_url,
        );

  factory LastAccessedModuleModel.fromJson(Map<String, dynamic> json) {
    return LastAccessedModuleModel(
      moduleId: json['moduleId'] ?? 0,
      courseName: json['courseName']?.toString().trim() ?? '',
      moduleName: json['moduleName'] ?? '',
      moduleDescription: json['moduleDescription'] ?? '',
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      progressPercentage: json['progressPercentage'] ?? 0.0,
      image_url: json['courseImage'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'courseName': courseName,
      'moduleName': moduleName,
      'moduleDescription': moduleDescription,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'progressPercentage': progressPercentage,
      'courseImage': image_url,
    };
  }
}
