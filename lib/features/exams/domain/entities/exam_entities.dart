import 'package:equatable/equatable.dart';

/// Represents a single exam/test
class Exam extends Equatable {
  final String id;
  final String title;
  final String subject;
  final int duration; // in minutes
  final int totalQuestions;
  final int currentQuestion;
  final String studentName;
  final String studentImage;
  final List<Question> questions;

  const Exam({
    required this.id,
    required this.title,
    required this.subject,
    required this.duration,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.studentName,
    required this.studentImage,
    required this.questions,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    duration,
    totalQuestions,
    currentQuestion,
    studentName,
    studentImage,
    questions,
  ];
}

/// Represents a single exam question
class Question extends Equatable {
  final String id;
  final int questionNumber;
  final String type; // 'multiple_choice', 'true_false', etc.
  final String text;
  final String description;
  final String? imageUrl;
  final List<QuestionOption> options;
  final String? userAnswer;
  final String explanation;

  const Question({
    required this.id,
    required this.questionNumber,
    required this.type,
    required this.text,
    required this.description,
    this.imageUrl,
    required this.options,
    this.userAnswer,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
    id,
    questionNumber,
    type,
    text,
    description,
    imageUrl,
    options,
    userAnswer,
    explanation,
  ];

  /// Create a copy of this question with updated fields
  Question copyWith({
    String? id,
    int? questionNumber,
    String? type,
    String? text,
    String? description,
    String? imageUrl,
    List<QuestionOption>? options,
    String? userAnswer,
    String? explanation,
  }) {
    return Question(
      id: id ?? this.id,
      questionNumber: questionNumber ?? this.questionNumber,
      type: type ?? this.type,
      text: text ?? this.text,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      options: options ?? this.options,
      userAnswer: userAnswer ?? this.userAnswer,
      explanation: explanation ?? this.explanation,
    );
  }
}

/// Represents a single option in a multiple choice question
class QuestionOption extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;

  const QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [id, text, isCorrect];
}

/// Represents exam results/submission
class ExamResult extends Equatable {
  final String examId;
  final String studentId;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double score; // percentage
  final DateTime submittedAt;
  final Map<String, String> answers; // questionId -> answerId

  const ExamResult({
    required this.examId,
    required this.studentId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.score,
    required this.submittedAt,
    required this.answers,
  });

  @override
  List<Object?> get props => [
    examId,
    studentId,
    totalQuestions,
    correctAnswers,
    wrongAnswers,
    score,
    submittedAt,
    answers,
  ];
}