import 'package:equatable/equatable.dart';

class ModuleGrades extends Equatable {
  final int moduleId;
  final double averagePercentage;
  final int examsCount;
  final List<ExamDetail> examDetails;

  const ModuleGrades({
    required this.moduleId,
    required this.averagePercentage,
    required this.examsCount,
    required this.examDetails,
  });

  @override
  List<Object?> get props => [moduleId, averagePercentage, examsCount, examDetails];
}

class ExamDetail extends Equatable {
  final int examId;
  final String examTitle;
  final int highestScore;
  final int totalPoints;
  final double percentage;

  const ExamDetail({
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
