import 'package:algonaid_mobail_app/features/exams/domain/entities/exam_entities.dart';
import 'package:hive/hive.dart';

part 'exam_models.g.dart';

/// Model for Exam - extends Exam entity with JSON serialization
@HiveType(typeId: 6)
class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.title,
    super.description,
    required super.passingScore,
    required super.maxAttempts,
    required super.lessonId,
    super.questions,
  });

  /// Convert JSON to ExamModel
  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      passingScore: (json['passingScore'] as num?)?.toInt() ?? 0,
      maxAttempts: (json['maxAttempts'] as num?)?.toInt() ?? 0,
      lessonId: (json['lessonId'] as num?)?.toInt() ?? 0,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Convert ExamModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'passingScore': passingScore,
      'maxAttempts': maxAttempts,
      'lessonId': lessonId,
      'questions': questions.map((q) => (q as QuestionModel).toJson()).toList(),
    };
  }
}

/// Model for Question - extends Question entity with JSON serialization
@HiveType(typeId: 7)
class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.points,
    required super.examId,
    super.options,
    super.description,
    super.imageUrl,
    super.explanation,
    super.userAnswer,
  });

  /// Convert JSON to QuestionModel
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'MULTIPLE_CHOICE',
      points: json.containsKey('points') ? (json['points'] as num).toInt() : 0,
      examId: (json['examId'] as num?)?.toInt() ?? 0,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((o) => OptionModel.fromJson(o as Map<String, dynamic>))
              .toList() ??
          const [],
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      explanation: json['explanation'] as String?,
      userAnswer: (json['userAnswer'] as num?)?.toInt(),
    );
  }

  /// Convert QuestionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'points': points,
      'examId': examId,
      'options': options.map((o) => (o as OptionModel).toJson()).toList(),
      'description': description,
      'imageUrl': imageUrl,
      'explanation': explanation,
      'userAnswer': userAnswer,
    };
  }

  @override
  QuestionModel copyWith({
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
    return QuestionModel(
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

/// Model for Option - extends Option entity with JSON serialization
@HiveType(typeId: 8)
class OptionModel extends Option {
  const OptionModel({
    required super.id,
    required super.text,
    required super.isCorrect,
    required super.questionId,
  });

  /// Convert JSON to OptionModel
  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
      questionId: (json['questionId'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert OptionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCorrect': isCorrect,
      'questionId': questionId,
    };
  }
}

/// Model for ExamAttempt - extends ExamAttempt entity with JSON serialization
@HiveType(typeId: 9)
class ExamAttemptModel extends ExamAttempt {
  const ExamAttemptModel({
    required super.id,
    required super.score,
    required super.status,
    required super.startedAt,
    super.completedAt,
    required super.studentId,
    required super.examId,
    super.answers,
    super.questions,
  });

  /// Convert JSON to ExamAttemptModel
  factory ExamAttemptModel.fromJson(Map<String, dynamic> json) {
    return ExamAttemptModel(
      id: (json['id'] as num).toInt(),
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'IN_PROGRESS',
      startedAt: DateTime.parse(
        json['startedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      studentId: (json['studentId'] as num?)?.toInt() ?? 0,
      examId: (json['examId'] as num?)?.toInt() ?? 0,
      answers:
          (json['answers'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v as int),
          ) ??
          const {},
      questions:
          (json['questions'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(QuestionModel.fromJson)
              .toList() ??
          const [],
    );
  }

  factory ExamAttemptModel.fromStartJson(
    Map<String, dynamic> json, {
    required int examId,
  }) {
    return ExamAttemptModel(
      id: (json['attemptId'] as num).toInt(),
      score: 0,
      status: json['status'] as String? ?? 'IN_PROGRESS',
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : DateTime.now(),
      studentId: (json['studentId'] as num?)?.toInt() ?? 0,
      examId: (json['examId'] as num?)?.toInt() ?? examId,
      questions: (json['questions'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(
            (questionJson) =>
                QuestionModel.fromJson({...questionJson, 'examId': examId}),
          )
          .toList(),
    );
  }

  /// Convert ExamAttemptModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'status': status,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'studentId': studentId,
      'examId': examId,
      'answers': answers.map((k, v) => MapEntry(k.toString(), v)),
      'questions': questions
          .map((question) => (question as QuestionModel).toJson())
          .toList(),
    };
  }
}

/// Model for ExamResult - extends ExamResult entity with JSON serialization
// Assuming ExamResult is similar to ExamAttempt for now, but specialized for results view
@HiveType(typeId: 10) // Changed typeId to avoid conflict
class ExamResultModel extends ExamResult {
  const ExamResultModel({
    required super.attemptId,
    required super.examId,
    required super.studentId,
    required super.score,
    required super.status,
    required super.submittedAt,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.wrongAnswers,
    required super.answers,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel.fromResultJson(json);
  }

  factory ExamResultModel.fromSubmissionJson(Map<String, dynamic> json) {
    final exam = json['exam'] as Map<String, dynamic>?;
    return ExamResultModel(
      attemptId: (json['id'] as num).toInt(),
      examId:
          (json['examId'] as num?)?.toInt() ??
          (exam?['id'] as num?)?.toInt() ??
          0,
      studentId: (json['studentId'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'FAILED',
      submittedAt: DateTime.parse(
        json['completedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      totalQuestions: (exam?['questions'] as List?)?.length ?? 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      answers: const {},
    );
  }

  factory ExamResultModel.fromResultJson(Map<String, dynamic> json) {
    final answersList = (json['answers'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final examJson = json['exam'] as Map<String, dynamic>?;
    final examQuestions =
        (examJson?['questions'] as List<dynamic>? ?? const []);

    final totalQuestions = examQuestions.length;
    final answers = <int, int>{};
    var correctAnswers = 0;

    for (final answerJson in answersList) {
      final questionJson = answerJson['question'] as Map<String, dynamic>?;
      final selectedOptionJson =
          answerJson['selectedOption'] as Map<String, dynamic>?;
      final questionId =
          (answerJson['questionId'] as num?)?.toInt() ??
          (questionJson?['id'] as num?)?.toInt();
      final selectedOptionId =
          (answerJson['selectedOptionId'] as num?)?.toInt() ??
          (selectedOptionJson?['id'] as num?)?.toInt();

      if (questionId != null && selectedOptionId != null) {
        answers[questionId] = selectedOptionId;
      }

      if ((selectedOptionJson?['isCorrect'] as bool?) ?? false) {
        correctAnswers++;
      }
    }

    return ExamResultModel(
      attemptId: (json['id'] as num).toInt(),
      examId:
          (json['examId'] as num?)?.toInt() ??
          (examJson?['id'] as num?)?.toInt() ??
          0,
      studentId: (json['studentId'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'FAILED',
      submittedAt: DateTime.parse(
        json['completedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      wrongAnswers: totalQuestions - correctAnswers,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': attemptId,
      'examId': examId,
      'studentId': studentId,
      'score': score,
      'status': status,
      'completedAt': submittedAt.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'answers': answers.map((k, v) => MapEntry(k.toString(), v)),
    };
  }
}
