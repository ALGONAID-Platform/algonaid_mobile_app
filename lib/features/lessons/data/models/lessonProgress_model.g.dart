// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessonProgress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonProgressModelAdapter extends TypeAdapter<LessonProgressModel> {
  @override
  final int typeId = 11;

  @override
  LessonProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonProgressModel(
      id: fields[0] as int? ?? 0,
      isCompleted: fields[1] as bool? ?? false,
      completedAt: fields[2] as DateTime?,
      studentId: fields[3] as int? ?? 0,
      lessonId: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, LessonProgressModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.completedAt)
      ..writeByte(3)
      ..write(obj.studentId)
      ..writeByte(4)
      ..write(obj.lessonId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
