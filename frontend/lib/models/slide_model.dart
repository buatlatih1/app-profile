import '../core/network/api_client.dart';

class SlideModel {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final String? linkUrl;
  final int sortOrder;

  SlideModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.linkUrl,
    this.sortOrder = 0,
  });

  String? get resolvedImageUrl => ApiClient.resolveImageUrl(image);

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      linkUrl: json['link_url']?.toString(),
      sortOrder: json['sort_order'] is int ? json['sort_order'] : 0,
    );
  }
}

