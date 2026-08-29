import 'package:algonaid/core/constants/endpoints.dart';
import 'package:algonaid/core/network/api_service.dart';
import 'package:algonaid/features/practice_exams/data/models/practice_exam_model.dart';

abstract class PracticeExamsRemoteDataSource {
  Future<List<PracticeExamModel>> getPracticeExams(int courseId);
}

class PracticeExamsRemoteDataSourceImpl implements PracticeExamsRemoteDataSource {
  final ApiService apiService;

  PracticeExamsRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<PracticeExamModel>> getPracticeExams(int courseId) async {
    final response = await apiService.get(
      endpoint: EndPoint.practiceExamsByCourse(courseId),
    );
    
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => PracticeExamModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
