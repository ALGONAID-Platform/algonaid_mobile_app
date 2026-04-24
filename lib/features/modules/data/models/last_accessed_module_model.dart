import 'package:algonaid_mobail_app/features/modules/domain/entities/last_accessed_module_entity.dart';
import 'package:hive/hive.dart';

part 'last_accessed_module_model.g.dart';

@HiveType(typeId: 7)
class LastAccessedModuleModel extends LastAccessedModuleEntity {
  @override
  @HiveField(0)
  final int moduleId;

  @override
  @HiveField(1)
  final String courseName;

  @override
  @HiveField(2)
  final String moduleName;

  @override
  @HiveField(3)
  final String moduleDescription;

  @override
  @HiveField(4)
  final int totalLessons;

  @override
  @HiveField(5)
  final int completedLessons;

  @override
  @HiveField(6)
  final num progressPercentage;

  @override
  @HiveField(7)
  final String image_url;

  const LastAccessedModuleModel({
    required this.moduleId,
    required this.courseName,
    required this.moduleName,
    required this.moduleDescription,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.image_url,
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
