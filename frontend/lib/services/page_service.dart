import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/page_model.dart';

class PageService {
  final ApiClient apiClient;

  PageService(this.apiClient);

  Future<List<PageModel>> getPages() async {
    final response = await apiClient.get(ApiConstants.pages);

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => PageModel.fromJson(item))
          .toList();
    }

    return [];
  }

  Future<PageModel> getPageBySlug(String slug) async {
    final response = await apiClient.get('${ApiConstants.pages}/$slug');

    if (response is Map<String, dynamic> && response['data'] is Map<String, dynamic>) {
      return PageModel.fromJson(response['data'] as Map<String, dynamic>);
    }

    throw ApiException('Halaman tidak ditemukan');
  }
}

