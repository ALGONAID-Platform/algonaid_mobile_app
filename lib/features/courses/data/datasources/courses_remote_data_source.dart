import 'package:algonaid_mobail_app/features/courses/data/models/continue_learning_model.dart';
import 'package:algonaid_mobail_app/features/courses/data/models/course_model.dart';

/// مصدر بعيد لبيانات الدورات. عند جاهزية الـ API، مرّر [ApiService] واربط الطرق بالمسارات.
abstract class CoursesRemoteDataSource {
  Future<List<CourseModel>> fetchCatalog();

  Future<ContinueLearningModel?> fetchContinueLearning();
}

class CoursesRemoteDataSourceImpl implements CoursesRemoteDataSource {
  const CoursesRemoteDataSourceImpl();

  @override
  Future<List<CourseModel>> fetchCatalog() async {
    // TODO: استبدل بـ _api.get(endpoint: EndPoint.coursesCatalog) عند الجاهزية.
    return const [];
  }

  @override
  Future<ContinueLearningModel?> fetchContinueLearning() async {
    // TODO: ربط بنقطة نهاية «متابعة التعلم».
    return null;
  }
}
