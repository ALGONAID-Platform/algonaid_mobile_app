// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamModelAdapter extends TypeAdapter<ExamModel> {
  @override
  final int typeId = 6;

  @override
  ExamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamModel(
      id: fields[0] as int? ?? 0,
      title: fields[1] as String? ?? '',
      description: fields[2] as String?,
      passingScore: fields[3] as int? ?? 0,
      maxAttempts: fields[4] as int? ?? 0,
      lessonId: fields[5] as int? ?? 0,
      questions: (fields[6] as List?)?.cast<Question>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, ExamModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.passingScore)
      ..writeByte(4)
      ..write(obj.maxAttempts)
      ..writeByte(5)
      ..write(obj.lessonId)
      ..writeByte(6)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 7;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      id: fields[0] as int? ?? 0,
      text: fields[1] as String? ?? '',
      type: fields[2] as String? ?? 'MULTIPLE_CHOICE',
      points: fields[3] as int? ?? 0,
      examId: fields[4] as int? ?? 0,
      options: (fields[5] as List?)?.cast<Option>() ?? const [],
      description: fields[6] as String?,
      imageUrl: fields[7] as String?,
      explanation: fields[8] as String?,
      userAnswer: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.points)
      ..writeByte(4)
      ..write(obj.examId)
      ..writeByte(5)
      ..write(obj.options)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.explanation)
      ..writeByte(9)
      ..write(obj.userAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OptionModelAdapter extends TypeAdapter<OptionModel> {
  @override
  final int typeId = 8;

  @override
  OptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptionModel(
      id: fields[0] as int? ?? 0,
      text: fields[1] as String? ?? '',
      isCorrect: fields[2] as bool? ?? false,
      questionId: fields[3] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, OptionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isCorrect)
      ..writeByte(3)
      ..write(obj.questionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExamAttemptModelAdapter extends TypeAdapter<ExamAttemptModel> {
  @override
  final int typeId = 9;

  @override
  ExamAttemptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamAttemptModel(
      id: fields[0] as int? ?? 0,
      score: fields[1] as int? ?? 0,
      status: fields[2] as String? ?? 'IN_PROGRESS',
      startedAt: fields[3] as DateTime? ?? DateTime.now(),
      completedAt: fields[4] as DateTime?,
      studentId: fields[5] as int? ?? 0,
      examId: fields[6] as int? ?? 0,
      answers: (fields[7] as Map?)?.cast<int, int>() ?? const {},
      questions: (fields[8] as List?)?.cast<Question>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, ExamAttemptModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.studentId)
      ..writeByte(6)
      ..write(obj.examId)
      ..writeByte(7)
      ..write(obj.answers)
      ..writeByte(8)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamAttemptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExamResultModelAdapter extends TypeAdapter<ExamResultModel> {
  @override
  final int typeId = 10;

  @override
  ExamResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResultModel(
      attemptId: fields[0] as int? ?? 0,
      examId: fields[1] as int? ?? 0,
      studentId: fields[2] as int? ?? 0,
      score: fields[3] as int? ?? 0,
      status: fields[4] as String? ?? 'FAILED',
      submittedAt: fields[5] as DateTime? ?? DateTime.now(),
      totalQuestions: fields[6] as int? ?? 0,
      correctAnswers: fields[7] as int? ?? 0,
      wrongAnswers: fields[8] as int? ?? 0,
      answers: (fields[9] as Map?)?.cast<int, int>() ?? const {},
    );
  }

  @override
  void write(BinaryWriter writer, ExamResultModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.attemptId)
      ..writeByte(1)
      ..write(obj.examId)
      ..writeByte(2)
      ..write(obj.studentId)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.submittedAt)
      ..writeByte(6)
      ..write(obj.totalQuestions)
      ..writeByte(7)
      ..write(obj.correctAnswers)
      ..writeByte(8)
      ..write(obj.wrongAnswers)
      ..writeByte(9)
      ..write(obj.answers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
