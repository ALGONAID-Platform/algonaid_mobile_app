// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonModelAdapter extends TypeAdapter<LessonModel> {
  @override
  final int typeId = 4;

  @override
  LessonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      videoUrl: fields[11] as String?,
      pdfUrl: fields[12] as String?,
      moduleId: fields[3] as int,
      order: fields[4] as int,
      lessonProgress: (fields[5] as List?)?.cast<LessonProgress>(),
      status: fields[6] as LessonStatus,
      content: fields[7] as String?,
      isReading: fields[8] as bool,
      hasExam: fields[9] as bool,
      hasTest: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LessonModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.moduleId)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.lessonProgress)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.content)
      ..writeByte(8)
      ..write(obj.isReading)
      ..writeByte(9)
      ..write(obj.hasExam)
      ..writeByte(10)
      ..write(obj.hasTest)
      ..writeByte(11)
      ..write(obj.videoUrl)
      ..writeByte(12)
      ..write(obj.pdfUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
