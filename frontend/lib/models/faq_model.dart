import 'question_topic_model.dart';

class FaqModel {
  final int id;
  final QuestionTopicModel? topic;
  final String question;
  final String answer;
  final int sortOrder;

  FaqModel({
    required this.id,
    this.topic,
    required this.question,
    required this.answer,
    this.sortOrder = 0,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      topic: json['topic'] is Map<String, dynamic>
          ? QuestionTopicModel.fromJson(json['topic'] as Map<String, dynamic>)
          : null,
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      sortOrder: json['sort_order'] is int ? json['sort_order'] : 0,
    );
  }
}

