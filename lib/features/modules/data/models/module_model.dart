import 'package:algonaid_mobail_app/features/lessons/data/models/lesson_model.dart';
import 'package:algonaid_mobail_app/features/modules/domain/entities/module.dart';
import 'package:hive/hive.dart';

part 'module_model.g.dart';

@HiveType(typeId: 5)
class ModuleModel extends Module {
  const ModuleModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.title,
    @HiveField(2) required super.description,
    @HiveField(3) required super.courseId,
    @HiveField(4) required super.lessons,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      courseId: json['courseId'] as int,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'lessons': lessons.map((e) => (e as LessonModel).toJson()).toList(),
    };
  }
}
