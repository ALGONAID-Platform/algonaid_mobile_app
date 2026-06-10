import 'package:hive/hive.dart'; // 🌟 إضافة هايف
import 'package:algonaid_mobile_app/features/courses/data/models/user_model.dart';
import 'package:algonaid_mobile_app/features/courses/data/models/teacher_model.dart';
import 'package:algonaid_mobile_app/features/courses/domain/entities/course_entity.dart';

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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      instructorId:
          int.tryParse(
            json['instructorId']?.toString() ??
                json['instructor_id']?.toString() ??
                '0',
          ) ??
          0,
      teacher: json['teacher'] != null
          ? TeacherModel.fromJson(json['teacher'])
          : TeacherModel(
              id: 0,
              specialization: '',
              experience: 0,
              userId: 0,
              user: UserModel(name: 'غير معروف', email: ''),
            ),
      moduleTitles:
          (json['moduleTitles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['module_titles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      modulesCount:
          int.tryParse(
            json['modulesCount']?.toString() ??
                json['modules_count']?.toString() ??
                '0',
          ) ??
          0,
      isEnrolled: json['isEnrolled'] == true || json['is_enrolled'] == true,
      totalLessons:
          int.tryParse(
            json['totalLessons']?.toString() ??
                json['total_lessons']?.toString() ??
                '0',
          ) ??
          0,
      completedLessons:
          int.tryParse(
            json['completedLessons']?.toString() ??
                json['completed_lessons']?.toString() ??
                '0',
          ) ??
          0,
      progressPercentage:
          double.tryParse(
            json['progressPercentage']?.toString() ??
                json['progress_percentage']?.toString() ??
                '0.0',
          ) ??
          0.0,
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
      teacher: TeacherModel.fromEntity(
        entity.teacher,
      ), // تأكد من وجودها في TeacherModel
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

  CourseEntity toEntity() =>
      this; // بما أنه يرث منها، يمكنك إرجاع الكائن نفسه أو استخدامه مباشرة
}
