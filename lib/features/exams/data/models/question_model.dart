// algonaid_mobail_app/lib/features/exams/data/models/question_model.dart
import 'package:algonaid_mobail_app/features/exams/data/models/option_model.dart';
import 'package:algonaid_mobail_app/features/exams/domain/entities/question.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.points,
    super.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      type: QuestionType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type']),
      points: json['points'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((o) => OptionModel.fromJson(o))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'points': points,
      'options': options?.map((o) => (o as OptionModel).toJson()).toList(),
    };
  }
}
