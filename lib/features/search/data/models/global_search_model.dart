import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';
import 'package:algonaid_mobail_app/features/search/domain/entities/global_search_entity.dart';

class GlobalSearchModel extends GlobalSearchEntity {
  GlobalSearchModel({
    required List<CourseModel> courses,
    required List<SearchModuleModel> modules,
    required List<SearchLessonModel> lessons,
  }) : super(courses: courses, modules: modules, lessons: lessons);

  factory GlobalSearchModel.fromJson(Map<String, dynamic> json) {
    return GlobalSearchModel(
      courses: (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => SearchModuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => SearchLessonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SearchModuleModel extends SearchModuleEntity {
  SearchModuleModel({
    required super.id,
    required super.title,
    required super.courseId,
  });

  factory SearchModuleModel.fromJson(Map<String, dynamic> json) {
    return SearchModuleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      courseId: (json['courseId'] as num?)?.toInt() ?? 
                (json['course_id'] as num?)?.toInt() ?? 0,
    );
  }
}

class SearchLessonModel extends SearchLessonEntity {
  SearchLessonModel({
    required super.id,
    required super.title,
    required super.moduleId,
    required super.courseId,
  });

  factory SearchLessonModel.fromJson(Map<String, dynamic> json) {
    return SearchLessonModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      moduleId: (json['moduleId'] as num?)?.toInt() ?? 
                (json['module_id'] as num?)?.toInt() ?? 0,
      courseId: (json['courseId'] as num?)?.toInt() ?? 
                (json['course_id'] as num?)?.toInt() ?? 0,
    );
  }
}
