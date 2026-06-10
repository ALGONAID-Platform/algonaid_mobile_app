import 'package:algonaid_mobile_app/features/modules/domain/entities/module_grades.dart';

class ModuleGradesModel extends ModuleGrades {
  const ModuleGradesModel({
    required super.moduleId,
    required super.averagePercentage,
    required super.examsCount,
    required super.examDetails,
  });

  factory ModuleGradesModel.fromJson(Map<String, dynamic> json) {
    return ModuleGradesModel(
      moduleId: (json['moduleId'] as num?)?.toInt() ?? 0,
      averagePercentage: (json['averagePercentage'] as num?)?.toDouble() ?? 0.0,
      examsCount: (json['examsCount'] as num?)?.toInt() ?? 0,
      examDetails: (json['examDetails'] as List<dynamic>?)
              ?.map((e) => ExamDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'averagePercentage': averagePercentage,
      'examsCount': examsCount,
      'examDetails': examDetails.map((e) => (e as ExamDetailModel).toJson()).toList(),
    };
  }
}

class ExamDetailModel extends ExamDetail {
  const ExamDetailModel({
    required super.examId,
    required super.examTitle,
    required super.highestScore,
    required super.totalPoints,
    required super.percentage,
  });

  factory ExamDetailModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailModel(
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
