import 'package:algonaid_mobail_app/features/courses/domain/entities/course_entity.dart';

class GlobalSearchEntity {
  final List<CourseEntity> courses;
  final List<SearchModuleEntity> modules;
  final List<SearchLessonEntity> lessons;

  GlobalSearchEntity({
    required this.courses,
    required this.modules,
    required this.lessons,
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
