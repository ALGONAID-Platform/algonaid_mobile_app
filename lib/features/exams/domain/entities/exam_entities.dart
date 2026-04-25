import 'package:equatable/equatable.dart';

/// Represents a single exam/test
class Exam extends Equatable {
  final int id;
  final String title;
  final String? description;
  final int passingScore;
  final int maxAttempts;
  final int lessonId;
  final List<Question> questions; // Questions are part of the exam details

  const Exam({
    required this.id,
    required this.title,
    this.description,
    required this.passingScore,
    required this.maxAttempts,
    required this.lessonId,
    this.questions = const [], // Initialize as empty list
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    passingScore,
    maxAttempts,
    lessonId,
    questions,
  ];

  int get totalQuestions => questions.length;

  Exam copyWith({
    int? id,
    String? title,
    String? description,
    int? passingScore,
    int? maxAttempts,
    int? lessonId,
    List<Question>? questions,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      passingScore: passingScore ?? this.passingScore,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lessonId: lessonId ?? this.lessonId,
      questions: questions ?? this.questions,
    );
  }
}

/// Represents a single exam question
class Question extends Equatable {
  final int id;
  final String text;
  final String type; // e.g., 'MULTIPLE_CHOICE', 'TRUE_FALSE'
  final int points;
  final int examId;
  final List<Option> options;
  final String? description;
  final String? imageUrl;
  final String? explanation;
  final int? userAnswer;

  const Question({
    required this.id,
    required this.text,
    required this.type,
    required this.points,
    required this.examId,
    this.options = const [], // Initialize as empty list
    this.description,
    this.imageUrl,
    this.explanation,
    this.userAnswer,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    type,
    points,
    examId,
    options,
    description,
    imageUrl,
    explanation,
    userAnswer,
  ];

  Question copyWith({
    int? id,
    String? text,
    String? type,
    int? points,
    int? examId,
    List<Option>? options,
    String? description,
    String? imageUrl,
    String? explanation,
    int? userAnswer,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      points: points ?? this.points,
      examId: examId ?? this.examId,
      options: options ?? this.options,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      explanation: explanation ?? this.explanation,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }
}

/// Represents a single option in a multiple choice question
class Option extends Equatable {
  final int id;
  final String text;
  final bool isCorrect; // Only relevant for results/admin view
  final int questionId;

  const Option({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.questionId,
  });

  @override
  List<Object?> get props => [id, text, isCorrect, questionId];
}

/// Represents an attempt at an exam by a student
class ExamAttempt extends Equatable {
  final int id;
  final int score;
  final String status; // e.g., 'IN_PROGRESS', 'PASSED', 'FAILED'
  final DateTime startedAt;
  final DateTime? completedAt;
  final int studentId;
  final int examId;
  final Map<int, int> answers; // questionId -> selectedOptionId
  final List<Question> questions;

  const ExamAttempt({
    required this.id,
    required this.score,
    required this.status,
    required this.startedAt,
    this.completedAt,
    required this.studentId,
    required this.examId,
    this.answers = const {},
    this.questions = const [],
  });

  @override
  List<Object?> get props => [
    id,
    score,
    status,
    startedAt,
    completedAt,
    studentId,
    examId,
    answers,
    questions,
  ];

  ExamAttempt copyWith({
    int? id,
    int? score,
    String? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? studentId,
    int? examId,
    Map<int, int>? answers,
    List<Question>? questions,
  }) {
    return ExamAttempt(
      id: id ?? this.id,
      score: score ?? this.score,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      studentId: studentId ?? this.studentId,
      examId: examId ?? this.examId,
      answers: answers ?? this.answers,
      questions: questions ?? this.questions,
    );
  }
}

/// Represents exam results, could be same as ExamAttempt but for clarity
/// Keeping it separate as the API might return a specialized result object
class ExamResult extends Equatable {
  final int attemptId;
  final int examId;
  final int studentId;
  final int score;
  final String status;
  final DateTime submittedAt;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Map<int, int> answers; // questionId -> selectedOptionId

  const ExamResult({
    required this.attemptId,
    required this.examId,
    required this.studentId,
    required this.score,
    required this.status,
    required this.submittedAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.answers,
  });

  @override
  List<Object?> get props => [
    attemptId,
    examId,
    studentId,
    score,
    status,
    submittedAt,
    totalQuestions,
    correctAnswers,
    wrongAnswers,
    answers,
  ];
}
