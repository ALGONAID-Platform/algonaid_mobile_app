// algonaid_mobail_app/lib/features/exams/domain/entities/question.dart
import 'package:algonaid_mobail_app/features/exams/domain/entities/option.dart';
import 'package:equatable/equatable.dart';

enum QuestionType { SINGLE_CHOICE, MULTIPLE_CHOICE, TRUE_FALSE } // Matches Prisma schema

class Question extends Equatable {
  final int id;
  final String text;
  final QuestionType type;
  final int points;
  final List<Option>? options; // Populated for multiple/single choice

  const Question({
    required this.id,
    required this.text,
    required this.type,
    required this.points,
    this.options,
  });

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        points,
        options,
      ];
}
