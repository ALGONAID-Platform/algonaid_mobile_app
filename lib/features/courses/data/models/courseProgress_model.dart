
import 'package:algonaid_mobail_app/features/courses/domain/entities/courseProgress_entity.dart';
import 'package:hive/hive.dart';
part 'course_progress_model.g.dart'; 


@HiveType(typeId: 5)
class CourseProgressModel extends CourseProgressEntity {
  
  @HiveField(0)
  final int courseId;
  
  @HiveField(1)
  final int totalLessons;
  
  @HiveField(2)
  final int completedLessons;
  
  @HiveField(3)
  final double progressPercentage;

  const CourseProgressModel({
    required this.courseId,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
  }) : super(
          courseId: courseId,
          totalLessons: totalLessons,
          completedLessons: completedLessons,
          progressPercentage: progressPercentage,
        );

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      courseId: json['courseId'] as int,
      totalLessons: json['totalLessons'] as int,
      completedLessons: json['completedLessons'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
    );
  }

  // تحويل من Entity إلى Model للحفظ في الكاش
  factory CourseProgressModel.fromEntity(CourseProgressEntity entity) {
    return CourseProgressModel(
      courseId: entity.courseId,
      totalLessons: entity.totalLessons,
      completedLessons: entity.completedLessons,
      progressPercentage: entity.progressPercentage,
    );
  }

  // تحويل إلى JSON لإرساله للسيرفر إذا لزم الأمر
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'progressPercentage': progressPercentage,
    };
  }
}