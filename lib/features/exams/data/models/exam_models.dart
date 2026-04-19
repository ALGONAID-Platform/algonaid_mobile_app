import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:hive/hive.dart';

part 'exam_models.g.dart';

/// Model for Exam - extends Exam entity with JSON serialization
@HiveType(typeId: 6)
class ExamModel extends Exam {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String subject;
  @HiveField(3)
  final int duration;
  @HiveField(4)
  final int totalQuestions;
  @HiveField(5)
  final int currentQuestion;
  @HiveField(6)
  final String studentName;
  @HiveField(7)
  final String studentImage;
  @HiveField(8)
  final List<Question> questions;

  ExamModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.duration,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.studentName,
    required this.studentImage,
    required this.questions,
  }) : super(
         id: id,
         title: title,
         subject: subject,
         duration: duration,
         totalQuestions: totalQuestions,
         currentQuestion: currentQuestion,
         studentName: studentName,
         studentImage: studentImage,
         questions: questions,
       );

  /// Convert JSON to ExamModel
  factory ExamModel.fromJson(Map<String, dynamic> json) {
    final examData = json['exam'] as Map<String, dynamic>;

    return ExamModel(
      id: examData['id'] as String,
      title: examData['title'] as String,
      subject: examData['subject'] as String,
      duration: examData['duration'] as int,
      totalQuestions: examData['totalQuestions'] as int,
      currentQuestion: examData['currentQuestion'] as int,
      studentName: examData['studentName'] as String,
      studentImage: examData['studentImage'] as String,
      questions: (examData['questions'] as List<dynamic>)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert ExamModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'exam': {
        'id': id,
        'title': title,
        'subject': subject,
        'duration': duration,
        'totalQuestions': totalQuestions,
        'currentQuestion': currentQuestion,
        'studentName': studentName,
        'studentImage': studentImage,
        'questions': questions
            .map((q) => (q as QuestionModel).toJson())
            .toList(),
      },
    };
  }
}

/// Model for Question - extends Question entity with JSON serialization
@HiveType(typeId: 7)
class QuestionModel extends Question {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int questionNumber;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String text;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String? imageUrl;
  @HiveField(6)
  final List<QuestionOption> options;
  @HiveField(7)
  final String? userAnswer;
  @HiveField(8)
  final String explanation;

  QuestionModel({
    required this.id,
    required this.questionNumber,
    required this.type,
    required this.text,
    required this.description,
    this.imageUrl,
    required this.options,
    this.userAnswer,
    required this.explanation,
  }) : super(
         id: id,
         questionNumber: questionNumber,
         type: type,
         text: text,
         description: description,
         imageUrl: imageUrl,
         options: options,
         userAnswer: userAnswer,
         explanation: explanation,
       );

  /// Convert JSON to QuestionModel
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      questionNumber: json['questionNumber'] as int,
      type: json['type'] as String,
      text: json['text'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((o) => QuestionOptionModel.fromJson(o as Map<String, dynamic>))
          .toList(),
      userAnswer: json['userAnswer'] as String?,
      explanation: json['explanation'] as String,
    );
  }

  /// Convert QuestionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'type': type,
      'text': text,
      'description': description,
      'imageUrl': imageUrl,
      'options': options
          .map((o) => (o as QuestionOptionModel).toJson())
          .toList(),
      'userAnswer': userAnswer,
      'explanation': explanation,
    };
  }

  /// Override copyWith to return QuestionModel
  @override
  QuestionModel copyWith({
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
    return QuestionModel(
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

/// Model for QuestionOption - extends QuestionOption entity with JSON serialization
@HiveType(typeId: 8)
class QuestionOptionModel extends QuestionOption {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final bool isCorrect;

  QuestionOptionModel({
    required this.id,
    required this.text,
    required this.isCorrect,
  }) : super(id: id, text: text, isCorrect: isCorrect);

  /// Convert JSON to QuestionOptionModel
  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return QuestionOptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  /// Convert QuestionOptionModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isCorrect': isCorrect};
  }
}

/// Model for ExamResult
@HiveType(typeId: 9)
class ExamResultModel extends ExamResult {
  @HiveField(0)
  final String examId;
  @HiveField(1)
  final String studentId;
  @HiveField(2)
  final int totalQuestions;
  @HiveField(3)
  final int correctAnswers;
  @HiveField(4)
  final int wrongAnswers;
  @HiveField(5)
  final double score;
  @HiveField(6)
  final DateTime submittedAt;
  @HiveField(7)
  final Map<String, String> answers;

  ExamResultModel({
    required this.examId,
    required this.studentId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.score,
    required this.submittedAt,
    required this.answers,
  }) : super(
         examId: examId,
         studentId: studentId,
         totalQuestions: totalQuestions,
         correctAnswers: correctAnswers,
         wrongAnswers: wrongAnswers,
         score: score,
         submittedAt: submittedAt,
         answers: answers,
       );

  /// Convert JSON to ExamResultModel
  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      examId: json['examId'] as String,
      studentId: json['studentId'] as String,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      wrongAnswers: json['wrongAnswers'] as int,
      score: (json['score'] as num).toDouble(),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      answers: Map<String, String>.from(json['answers'] as Map),
    );
  }

  /// Convert ExamResultModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'examId': examId,
      'studentId': studentId,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'score': score,
      'submittedAt': submittedAt.toIso8601String(),
      'answers': answers,
    };
  }
}
