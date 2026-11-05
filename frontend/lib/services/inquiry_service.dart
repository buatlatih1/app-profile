import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/pagination_meta.dart';
import '../models/question_model.dart';
import '../models/question_topic_model.dart';

class InquiryService {
  final ApiClient apiClient;

  InquiryService(this.apiClient);

  Future<List<QuestionTopicModel>> getTopics() async {
    final response = await apiClient.get(ApiConstants.questionTopics);

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => QuestionTopicModel.fromJson(item))
          .toList();
    }

    return [];
  }

  Future<({List<QuestionModel> questions, PaginationMeta meta})> getQuestions({
    int page = 1,
    int perPage = 10,
    String? topic,
    String? query,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };

    if (topic != null && topic.trim().isNotEmpty) {
      params['topic'] = topic.trim();
    }
    if (query != null && query.trim().isNotEmpty) {
      params['q'] = query.trim();
    }

    final response = await apiClient.get(ApiConstants.questions, queryParameters: params);

    List<QuestionModel> questions = [];
    PaginationMeta meta = PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: perPage);

    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        questions = (response['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => QuestionModel.fromJson(item))
            .toList();
      }
      if (response['meta'] is Map<String, dynamic>) {
        meta = PaginationMeta.fromJson(response['meta'] as Map<String, dynamic>);
      }
    }

    return (questions: questions, meta: meta);
  }

  Future<Map<String, dynamic>> submitQuestion({
    required int topicId,
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String body,
  }) async {
    final payload = {
      'topic_id': topicId,
      'name': name.trim(),
      'email': email.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
      'subject': subject.trim(),
      'body': body.trim(),
    };

    final response = await apiClient.post(ApiConstants.questions, body: payload);

    if (response is Map<String, dynamic>) {
      return response;
    }

    return {'message': 'Pertanyaan berhasil dikirim'};
  }
}

