import '../core/network/api_client.dart';

class PageModel {
  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? image;
  final int sortOrder;
  final bool showInMenu;
  final DateTime? updatedAt;

  PageModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.image,
    this.sortOrder = 0,
    this.showInMenu = true,
    this.updatedAt,
  });

  String? get resolvedImageUrl => ApiClient.resolveImageUrl(image);

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      content: json['content']?.toString(),
      image: json['image']?.toString(),
      sortOrder: json['sort_order'] is int ? json['sort_order'] : 0,
      showInMenu: json['show_in_menu'] == true || json['show_in_menu'] == 1,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}

