// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleModelAdapter extends TypeAdapter<ModuleModel> {
  @override
  final int typeId = 5;

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
      lessons: fields[3] as List<LessonModel>,
      courseId: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleModel obj) {
    writer.writeByte(0);
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
