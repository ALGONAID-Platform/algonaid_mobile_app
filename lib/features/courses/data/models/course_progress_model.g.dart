
part of 'courseProgress_model.dart';

class CourseProgressModelAdapter extends TypeAdapter<CourseProgressModel> {
  @override
  final int typeId = 5; // 🌟 نفس الرقم الذي وضعته في الموديل

  @override
  CourseProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseProgressModel(
      courseId: fields[0] as int,
      totalLessons: fields[1] as int,
      completedLessons: fields[2] as int,
      progressPercentage: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CourseProgressModel obj) {
    writer
      ..writeByte(4) // عدد الحقول التي سنقوم بكتابتها
      ..writeByte(0)
      ..write(obj.courseId)
      ..writeByte(1)
      ..write(obj.totalLessons)
      ..writeByte(2)
      ..write(obj.completedLessons)
      ..writeByte(3)
      ..write(obj.progressPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}