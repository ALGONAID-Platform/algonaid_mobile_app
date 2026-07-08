import 'package:algonaid_mobile_app/features/practice_exams/domain/entities/practice_exam_entity.dart';

class PracticeExamModel extends PracticeExamEntity {
  PracticeExamModel({
    required super.id,
    required super.title,
    required super.description,
    required super.pdfUrl,
    required super.grade,
    required super.courseId,
    required super.createdAt,
  });

  factory PracticeExamModel.fromJson(Map<String, dynamic> json) {
    return PracticeExamModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      grade: json['grade'] ?? '',
      courseId: json['courseId'] is int ? json['courseId'] : int.parse(json['courseId'].toString()),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pdfUrl': pdfUrl,
      'grade': grade,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
