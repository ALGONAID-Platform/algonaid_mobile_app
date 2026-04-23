import 'package:hive/hive.dart'; // 🌟 إضافة هايف
import 'package:algonaid_mobail_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

part 'course_model.g.dart'; // 🌟 ضروري لتوليد ملف الـ Adapter

@HiveType(typeId: 1)
class CourseModel extends CourseEntity {
  
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String thumbnail;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime updatedAt;
  
  @HiveField(6)
  final int instructorId;
  
  @HiveField(7)
  final TeacherModel teacher; // تأكد أن TeacherModel أيضاً مسجل في Hive
  
  @HiveField(8)
  final List<String> moduleTitles;
  
  @HiveField(9)
  final int modulesCount;
  
  @HiveField(10)
  final bool isEnrolled;

  @HiveField(11, defaultValue: 0)
  final int totalLessons;

  @HiveField(12, defaultValue: 0)
  final int completedLessons;

  @HiveField(13, defaultValue: 0.0)
  final double progressPercentage;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
    required this.instructorId,
    required this.teacher,
    required this.moduleTitles,
    required this.modulesCount,
    required this.isEnrolled,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
  }) : super(
          id: id,
          title: title,
          description: description,
          thumbnail: thumbnail,
          createdAt: createdAt,
          updatedAt: updatedAt,
          instructorId: instructorId,
          teacher: teacher,
          moduleTitles: moduleTitles,
          modulesCount: modulesCount,
          isEnrolled: isEnrolled,
          totalLessons: totalLessons,
          completedLessons: completedLessons,
          progressPercentage: progressPercentage,
        );

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      instructorId: json['instructorId'] as int,
      teacher: TeacherModel.fromJson(json['teacher']),
      moduleTitles: (List<String>.from(json['moduleTitles'] ?? [])),
      modulesCount: json['modulesCount'] ?? 0,
      isEnrolled: json['isEnrolled'] ?? false,
      totalLessons: json['totalLessons'] ?? 0,
      completedLessons: json['completedLessons'] ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // دالة مفيدة عند الحفظ في الكاش (تحول الـ Entity القادم من الريبو إلى Model)
  factory CourseModel.fromEntity(CourseEntity entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      thumbnail: entity.thumbnail,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      instructorId: entity.instructorId,
      teacher: TeacherModel.fromEntity(entity.teacher), // تأكد من وجودها في TeacherModel
      moduleTitles: entity.moduleTitles,
      modulesCount: entity.modulesCount,
      isEnrolled: entity.isEnrolled,
      totalLessons: entity.totalLessons,
      completedLessons: entity.completedLessons,
      progressPercentage: entity.progressPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'instructorId': instructorId,
      'teacher': teacher.toJson(),
      'moduleTitles': moduleTitles,
      'modulesCount': modulesCount,
      'isEnrolled': isEnrolled,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'progressPercentage': progressPercentage,
    };
  }

  CourseEntity toEntity() => this; // بما أنه يرث منها، يمكنك إرجاع الكائن نفسه أو استخدامه مباشرة
}