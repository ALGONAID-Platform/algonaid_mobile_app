// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonStatusAdapter extends TypeAdapter<LessonStatus> {
  @override
  final int typeId = 20;

  @override
  LessonStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LessonStatus.notStarted;
      case 1:
        return LessonStatus.inProgress;
      case 2:
        return LessonStatus.completed;
      case 3:
        return LessonStatus.locked;
      default:
        return LessonStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, LessonStatus obj) {
    switch (obj) {
      case LessonStatus.notStarted:
        writer.writeByte(0);
        break;
      case LessonStatus.inProgress:
        writer.writeByte(1);
        break;
      case LessonStatus.completed:
        writer.writeByte(2);
        break;
      case LessonStatus.locked:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
