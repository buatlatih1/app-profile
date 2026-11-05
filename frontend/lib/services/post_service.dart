import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/pagination_meta.dart';
import '../models/post_model.dart';

class PostService {
  final ApiClient apiClient;

  PostService(this.apiClient);

  Future<({List<PostModel> posts, PaginationMeta meta})> getPosts({
    int page = 1,
    int perPage = 10,
    String? category,
    String? query,
    bool? featured,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };

    if (category != null && category.trim().isNotEmpty) {
      params['category'] = category.trim();
    }
    if (query != null && query.trim().isNotEmpty) {
      params['q'] = query.trim();
    }
    if (featured == true) {
      params['featured'] = 1;
    }

    final response = await apiClient.get(ApiConstants.posts, queryParameters: params);

    List<PostModel> posts = [];
    PaginationMeta meta = PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: perPage);

    if (response is Map<String, dynamic>) {
      if (response['data'] is List) {
        posts = (response['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((item) => PostModel.fromJson(item))
            .toList();
      }
      if (response['meta'] is Map<String, dynamic>) {
        meta = PaginationMeta.fromJson(response['meta'] as Map<String, dynamic>);
      }
    }

    return (posts: posts, meta: meta);
  }

  Future<PostModel> getPostBySlug(String slug) async {
    final response = await apiClient.get('${ApiConstants.posts}/$slug');

    if (response is Map<String, dynamic> && response['data'] is Map<String, dynamic>) {
      return PostModel.fromJson(response['data'] as Map<String, dynamic>);
    }

    throw ApiException('Format respons artikel tidak valid');
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(ApiConstants.categories);

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => CategoryModel.fromJson(item))
          .toList();
    }

    return [];
  }

  Future<CategoryModel> getCategoryBySlug(String slug) async {
    final response = await apiClient.get('${ApiConstants.categories}/$slug');

    if (response is Map<String, dynamic> && response['data'] is Map<String, dynamic>) {
      return CategoryModel.fromJson(response['data'] as Map<String, dynamic>);
    }

    throw ApiException('Format respons kategori tidak valid');
  }
}

