import 'package:equatable/equatable.dart';

class CourseGrades extends Equatable {
  final int courseId;
  final double averagePercentage;
  final int examsCount;
  final List<CourseExamDetail> examDetails;

  const CourseGrades({
    required this.courseId,
    required this.averagePercentage,
    required this.examsCount,
    required this.examDetails,
  });

  @override
  List<Object?> get props => [courseId, averagePercentage, examsCount, examDetails];
}

class CourseExamDetail extends Equatable {
  final int examId;
  final String examTitle;
  final int highestScore;
  final int totalPoints;
  final double percentage;

  const CourseExamDetail({
    required this.examId,
    required this.examTitle,
    required this.highestScore,
    required this.totalPoints,
    required this.percentage,
  });

  @override
  List<Object?> get props => [
        examId,
        examTitle,
        highestScore,
        totalPoints,
        percentage,
      ];
}
