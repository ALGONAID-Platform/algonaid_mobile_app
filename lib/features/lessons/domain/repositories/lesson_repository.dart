import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson_detail.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessonsByModule(int moduleId);
  Future<LessonDetail> getLessonDetail(int lessonId);
}
