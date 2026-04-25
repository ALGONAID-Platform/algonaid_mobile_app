// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_accessed_module_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LastAccessedModuleModelAdapter
    extends TypeAdapter<LastAccessedModuleModel> {
  @override
  final int typeId = 12;

  @override
  LastAccessedModuleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastAccessedModuleModel(
      moduleId: fields[0] as int,
      courseName: fields[1] as String,
      moduleName: fields[2] as String,
      moduleDescription: fields[3] as String,
      totalLessons: fields[4] as int,
      completedLessons: fields[5] as int,
      progressPercentage: fields[6] as num,
      image_url: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LastAccessedModuleModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.moduleId)
      ..writeByte(1)
      ..write(obj.courseName)
      ..writeByte(2)
      ..write(obj.moduleName)
      ..writeByte(3)
      ..write(obj.moduleDescription)
      ..writeByte(4)
      ..write(obj.totalLessons)
      ..writeByte(5)
      ..write(obj.completedLessons)
      ..writeByte(6)
      ..write(obj.progressPercentage)
      ..writeByte(7)
      ..write(obj.image_url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastAccessedModuleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
