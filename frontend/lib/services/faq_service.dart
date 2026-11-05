import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/faq_model.dart';

class FaqService {
  final ApiClient apiClient;

  FaqService(this.apiClient);

  Future<List<FaqModel>> getFaqs({String? topic, String? query}) async {
    final Map<String, dynamic> params = {};

    if (topic != null && topic.trim().isNotEmpty) {
      params['topic'] = topic.trim();
    }
    if (query != null && query.trim().isNotEmpty) {
      params['q'] = query.trim();
    }

    final response = await apiClient.get(ApiConstants.faqs, queryParameters: params);

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => FaqModel.fromJson(item))
          .toList();
    }

    return [];
  }
}

