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
      id: fields[0] as String,
      title: fields[1] as String,
      subject: fields[2] as String,
      duration: fields[3] as int,
      totalQuestions: fields[4] as int,
      currentQuestion: fields[5] as int,
      studentName: fields[6] as String,
      studentImage: fields[7] as String,
      questions: (fields[8] as List).cast<Question>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExamModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.totalQuestions)
      ..writeByte(5)
      ..write(obj.currentQuestion)
      ..writeByte(6)
      ..write(obj.studentName)
      ..writeByte(7)
      ..write(obj.studentImage)
      ..writeByte(8)
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
      id: fields[0] as String,
      questionNumber: fields[1] as int,
      type: fields[2] as String,
      text: fields[3] as String,
      description: fields[4] as String,
      imageUrl: fields[5] as String?,
      options: (fields[6] as List).cast<QuestionOption>(),
      userAnswer: fields[7] as String?,
      explanation: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionNumber)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.options)
      ..writeByte(7)
      ..write(obj.userAnswer)
      ..writeByte(8)
      ..write(obj.explanation);
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

class QuestionOptionModelAdapter extends TypeAdapter<QuestionOptionModel> {
  @override
  final int typeId = 8;

  @override
  QuestionOptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionOptionModel(
      id: fields[0] as String,
      text: fields[1] as String,
      isCorrect: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionOptionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionOptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExamResultModelAdapter extends TypeAdapter<ExamResultModel> {
  @override
  final int typeId = 9;

  @override
  ExamResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamResultModel(
      examId: fields[0] as String,
      studentId: fields[1] as String,
      totalQuestions: fields[2] as int,
      correctAnswers: fields[3] as int,
      wrongAnswers: fields[4] as int,
      score: fields[5] as double,
      submittedAt: fields[6] as DateTime,
      answers: (fields[7] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExamResultModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.examId)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.totalQuestions)
      ..writeByte(3)
      ..write(obj.correctAnswers)
      ..writeByte(4)
      ..write(obj.wrongAnswers)
      ..writeByte(5)
      ..write(obj.score)
      ..writeByte(6)
      ..write(obj.submittedAt)
      ..writeByte(7)
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
