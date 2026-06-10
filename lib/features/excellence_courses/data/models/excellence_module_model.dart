import 'package:algonaid_mobile_app/features/excellence_courses/domain/entities/excellence_module_entity.dart';

class ExcellenceModuleModel extends ExcellenceModuleEntity {
  const ExcellenceModuleModel({
    required super.moduleId,
    required super.moduleTitle,
    required super.courseId,
    required super.courseTitle,
    required super.averagePercentage,
    required super.isCompleted,
  });

  factory ExcellenceModuleModel.fromJson(Map<String, dynamic> json) {
    return ExcellenceModuleModel(
      moduleId: json['moduleId'] ?? 0,
      moduleTitle: json['moduleTitle'] ?? '',
      courseId: json['courseId'] ?? 0,
      courseTitle: json['courseTitle'] ?? '',
      averagePercentage: json['averagePercentage'] ?? 0.0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'moduleTitle': moduleTitle,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'averagePercentage': averagePercentage,
      'isCompleted': isCompleted,
    };
  }
}
