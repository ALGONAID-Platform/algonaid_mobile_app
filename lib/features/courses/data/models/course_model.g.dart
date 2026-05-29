// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseModelAdapter extends TypeAdapter<CourseModel> {
  @override
  final int typeId = 1;

  @override
  CourseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      thumbnail: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      instructorId: fields[6] as int,
      teacher: fields[7] as TeacherModel,
      moduleTitles: (fields[8] as List).cast<String>(),
      modulesCount: fields[9] as int,
      isEnrolled: fields[10] as bool,
      totalLessons: fields[11] == null ? 0 : fields[11] as int,
      completedLessons: fields[12] == null ? 0 : fields[12] as int,
      progressPercentage: fields[13] == null ? 0.0 : fields[13] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.instructorId)
      ..writeByte(7)
      ..write(obj.teacher)
      ..writeByte(8)
      ..write(obj.moduleTitles)
      ..writeByte(9)
      ..write(obj.modulesCount)
      ..writeByte(10)
      ..write(obj.isEnrolled)
      ..writeByte(11)
      ..write(obj.totalLessons)
      ..writeByte(12)
      ..write(obj.completedLessons)
      ..writeByte(13)
      ..write(obj.progressPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
