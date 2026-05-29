// algonaid_mobail_app/lib/features/exams/data/models/exam_model.dart
import 'package:algonaid_mobail_app/features/exams/data/models/question_model.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/exam.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.title,
    super.description,
    required super.passingScore,
    required super.maxAttempts,
    super.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      passingScore: json['passingScore'],
      maxAttempts: json['maxAttempts'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => QuestionModel.fromJson(q))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'passingScore': passingScore,
      'maxAttempts': maxAttempts,
      'questions': questions?.map((q) => (q as QuestionModel).toJson()).toList(),
    };
  }
}
