class QuestionTopicModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;

  QuestionTopicModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
  });

  factory QuestionTopicModel.fromJson(Map<String, dynamic> json) {
    return QuestionTopicModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
    );
  }
}

