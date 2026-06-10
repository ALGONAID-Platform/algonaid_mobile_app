import 'package:algonaid_mobile_app/features/courses/domain/entities/course_grades.dart';

class CourseGradesModel extends CourseGrades {
  const CourseGradesModel({
    required super.courseId,
    required super.averagePercentage,
    required super.examsCount,
    required super.examDetails,
  });

  factory CourseGradesModel.fromJson(Map<String, dynamic> json) {
    return CourseGradesModel(
      courseId: (json['courseId'] as num?)?.toInt() ?? 0,
      averagePercentage: (json['averagePercentage'] as num?)?.toDouble() ?? 0.0,
      examsCount: (json['examsCount'] as num?)?.toInt() ?? 0,
      examDetails:
          (json['examDetails'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CourseExamDetailModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'averagePercentage': averagePercentage,
      'examsCount': examsCount,
      'examDetails': examDetails
          .map((e) => (e as CourseExamDetailModel).toJson())
          .toList(),
    };
  }
}

class CourseExamDetailModel extends CourseExamDetail {
  const CourseExamDetailModel({
    required super.examId,
    required super.examTitle,
    required super.highestScore,
    required super.totalPoints,
    required super.percentage,
  });

  factory CourseExamDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseExamDetailModel(
      examId: (json['examId'] as num?)?.toInt() ?? 0,
      examTitle: json['examTitle'] as String? ?? '',
      highestScore: (json['highestScore'] as num?)?.toInt() ?? 0,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'examId': examId,
      'examTitle': examTitle,
      'highestScore': highestScore,
      'totalPoints': totalPoints,
      'percentage': percentage,
    };
  }
}
