import 'question_topic_model.dart';

class QuestionAnswerModel {
  final int? id;
  final String body;
  final String? authorName;
  final DateTime? answeredAt;

  QuestionAnswerModel({
    this.id,
    required this.body,
    this.authorName,
    this.answeredAt,
  });

  factory QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    String? author;
    if (json['author'] is Map<String, dynamic>) {
      author = json['author']['name']?.toString();
    } else if (json['author'] != null) {
      author = json['author'].toString();
    }

    return QuestionAnswerModel(
      id: json['id'] is int ? json['id'] : null,
      body: json['body']?.toString() ?? '',
      authorName: author,
      answeredAt: json['answered_at'] != null
          ? DateTime.tryParse(json['answered_at'].toString())
          : null,
    );
  }
}

class QuestionModel {
  final int id;
  final QuestionTopicModel? topic;
  final String name;
  final String subject;
  final String body;
  final String status;
  final DateTime? createdAt;
  final QuestionAnswerModel? answer;

  QuestionModel({
    required this.id,
    this.topic,
    required this.name,
    required this.subject,
    required this.body,
    required this.status,
    this.createdAt,
    this.answer,
  });

  bool get isAnswered => answer != null && answer!.body.trim().isNotEmpty;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      topic: json['topic'] is Map<String, dynamic>
          ? QuestionTopicModel.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      answer: json['answer'] is Map<String, dynamic>
          ? QuestionAnswerModel.fromJson(json['answer'] as Map<String, dynamic>)
          : null,
    );
  }
}

