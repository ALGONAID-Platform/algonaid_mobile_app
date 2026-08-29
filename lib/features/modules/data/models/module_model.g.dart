// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleModelAdapter extends TypeAdapter<ModuleModel> {
  @override
  final int typeId = 13;

  @override
  ModuleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      courseId: fields[3] as int,
      lessons: (fields[4] as List).cast<Lesson>(),
      completedLessons: fields[5] as int,
      progressPercentage: fields[6] as double,
      totalLessons: fields[7] as int,
      imageUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.courseId)
      ..writeByte(4)
      ..write(obj.lessons)
      ..writeByte(5)
      ..write(obj.completedLessons)
      ..writeByte(6)
      ..write(obj.progressPercentage)
      ..writeByte(7)
      ..write(obj.totalLessons)
      ..writeByte(8)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
