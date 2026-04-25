// algonaid_mobail_app/lib/features/exams/domain/entities/option.dart
import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final int id;
  final String text;
  final bool isCorrect; // Note: This might not be sent to client for security

  const Option({
    required this.id,
    required this.text,
    this.isCorrect = false, // Default to false for client-side representation
  });

  @override
  List<Object?> get props => [
        id,
        text,
        isCorrect,
      ];
}
