import 'package:algonaid_mobail_app/features/courses/domain/entities/course.dart';

/// عقد جلب بيانات الدورات (كتالوج، متابعة التعلم، …).
abstract class CoursesRepository {
  Future<List<Course>> getCatalog();

  /// يُرجع `null` إذا لا توجد دورة للمتابعة.
  Future<ContinueLearningCourse?> getContinueLearning();
}
