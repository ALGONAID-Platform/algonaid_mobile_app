import 'package:algonaid/features/courses/domain/entities/course_entity.dart';

class GlobalSearchEntity {
  final List<CourseEntity> courses;
  final List<SearchModuleEntity> modules;
  final List<SearchLessonEntity> lessons;
  final List<SearchPracticeExamEntity> practiceExams;

  GlobalSearchEntity({
    required this.courses,
    required this.modules,
    required this.lessons,
    required this.practiceExams,
  });
}

class SearchModuleEntity {
  final int id;
  final String title;
  final int courseId;

  SearchModuleEntity({
    required this.id,
    required this.title,
    required this.courseId,
  });
}

class SearchLessonEntity {
  final int id;
  final String title;
  final int moduleId;
  final int courseId;

  SearchLessonEntity({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.courseId,
  });
}

class SearchPracticeExamEntity {
  final int id;
  final String title;
  final String? grade;
  final String? pdfUrl;
  final int? courseId;
  final String? courseTitle;

  SearchPracticeExamEntity({
    required this.id,
    required this.title,
    this.grade,
    this.pdfUrl,
    this.courseId,
    this.courseTitle,
  });
}
