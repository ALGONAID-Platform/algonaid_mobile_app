// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherModelAdapter extends TypeAdapter<TeacherModel> {
  @override
  final int typeId = 2;

  @override
  TeacherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeacherModel(
      id: fields[0] as int,
      specialization: fields[1] as String,
      bio: fields[2] as String?,
      experience: fields[3] as int,
      userId: fields[4] as int,
      user: fields[5] as UserModel,
    );
  }

  @override
  void write(BinaryWriter writer, TeacherModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.specialization)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.experience)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
