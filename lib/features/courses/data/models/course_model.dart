
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnail,
    required super.createdAt,
    required super.updatedAt,
    required super.instructorId,
    required super.teacher,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      instructorId: json['instructorId'] as int,
      teacher: TeacherModel.fromJson(json['teacher']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'instructorId': instructorId,
      'teacher': (teacher as TeacherModel).toJson(),
    };
  }

  CourseEntity toEntity() {
    return CourseEntity(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      createdAt: createdAt,
      updatedAt: updatedAt,
      instructorId: instructorId,
      teacher: (teacher as TeacherModel).toEntity(),
    );
  }
}