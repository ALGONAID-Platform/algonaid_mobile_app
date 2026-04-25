import 'package:algonaid_mobail_app/core/constants/endpoints.dart';
import 'package:algonaid_mobail_app/core/errors/exceptions.dart';
import 'package:algonaid_mobail_app/core/network/api_service.dart';
import 'package:algonaid_mobail_app/features/exams/data/models/exam_models.dart';

abstract class ExamRemoteDataSource {
  Future<ExamModel> getExam(int examId);
  Future<ExamAttemptModel> startExam(int examId);
  Future<ExamResultModel> submitExam(int attemptId, Map<int, int> answers);
  Future<ExamResultModel> getExamResult(int attemptId);
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final ApiService apiService;

  ExamRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ExamModel> getExam(int examId) async {
    final response = await apiService.get(endpoint: EndPoint.startExam(examId));
    final examJson = _asMap(response, context: 'getExam');
    return ExamModel.fromJson(examJson);
  }

  @override
  Future<ExamAttemptModel> startExam(int examId) async {
    final response = await apiService.post(
      endpoint: EndPoint.startExam(examId),
      data: const <String, dynamic>{},
    );
    final startJson = _asMap(response, context: 'startExam');
    return ExamAttemptModel.fromStartJson(startJson, examId: examId);
  }

  @override
  Future<ExamResultModel> submitExam(
    int attemptId,
    Map<int, int> answers,
  ) async {
    final payload = {
      'answers': answers.entries
          .map(
            (entry) => {
              'questionId': entry.key,
              'selectedOptionId': entry.value,
            },
          )
          .toList(),
    };

    final response = await apiService.post(
      endpoint: EndPoint.submitExam(attemptId),
      data: payload,
    );

    final submitJson = _asMap(response, context: 'submitExam');
    return ExamResultModel.fromSubmissionJson(submitJson);
  }

  @override
  Future<ExamResultModel> getExamResult(int attemptId) async {
    final response = await apiService.get(
      endpoint: EndPoint.getExamResult(attemptId),
    );
    final resultJson = _asMap(response, context: 'getExamResult');
    return ExamResultModel.fromResultJson(resultJson);
  }

  Map<String, dynamic> _asMap(dynamic response, {required String context}) {
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        return response['data'] as Map<String, dynamic>;
      }
      return response;
    }

    throw ServerException('Invalid response for $context: $response');
  }
}
