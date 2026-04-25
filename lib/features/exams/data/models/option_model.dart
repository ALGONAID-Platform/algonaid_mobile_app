// algonaid_mobail_app/lib/features/exams/data/models/option_model.dart
import 'package:algonaid_mobail_app/features/exams/domain/entities/option.dart';

class OptionModel extends Option {
  const OptionModel({
    required super.id,
    required super.text,
    super.isCorrect,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'] ?? false, // API might not send this
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}
