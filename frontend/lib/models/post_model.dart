import '../core/network/api_client.dart';
import 'category_model.dart';

class AuthorModel {
  final int? id;
  final String name;
  final String? avatar;

  AuthorModel({this.id, required this.name, this.avatar});

  factory AuthorModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AuthorModel(name: 'Admin');
    return AuthorModel(
      id: json['id'] is int ? json['id'] : null,
      name: json['name']?.toString() ?? 'Admin',
      avatar: json['avatar']?.toString(),
    );
  }
}

class PostModel {
  final int id;
  final String title;
  final String slug;
  final String? summary;
  final String? content;
  final String? image;
  final CategoryModel? category;
  final AuthorModel? author;
  final int viewCount;
  final bool isFeatured;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    this.content,
    this.image,
    this.category,
    this.author,
    this.viewCount = 0,
    this.isFeatured = false,
    this.publishedAt,
    this.createdAt,
  });

  String? get resolvedImageUrl => ApiClient.resolveImageUrl(image);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      summary: json['summary']?.toString(),
      content: json['content']?.toString(),
      image: json['image']?.toString(),
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      author: json['author'] is Map<String, dynamic>
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      viewCount: json['view_count'] is int ? json['view_count'] : 0,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

