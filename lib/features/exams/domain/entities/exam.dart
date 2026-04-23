// algonaid_mobail_app/lib/features/exams/domain/entities/exam.dart
import 'package:algonaid_mobail_app/features/exams/domain/entities/question.dart';
import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int passingScore;
  final int maxAttempts;
  final List<Question>? questions; // Will be populated when exam is started

  const Exam({
    required this.id,
    required this.title,
    this.description,
    required this.passingScore,
    required this.maxAttempts,
    this.questions,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        passingScore,
        maxAttempts,
        questions,
      ];
}
