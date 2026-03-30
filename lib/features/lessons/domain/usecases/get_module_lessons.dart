import 'package:algonaid_mobail_app/features/lessons/domain/entities/lesson.dart';
import 'package:algonaid_mobail_app/features/lessons/domain/repositories/lesson_repository.dart';

class GetModuleLessons {
  final LessonRepository _repository;

  const GetModuleLessons(this._repository);

  Future<List<Lesson>> call(int moduleId) {
    return _repository.getLessonsByModule(moduleId);
  }
}
