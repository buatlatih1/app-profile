import 'package:flutter/material.dart';
import '../core/localization/locale_provider.dart';
import '../models/faq_model.dart';
import '../models/question_topic_model.dart';
import '../services/faq_service.dart';
import '../services/inquiry_service.dart';

class FaqProvider extends ChangeNotifier {
  final FaqService faqService;
  final InquiryService inquiryService;
  final LocaleProvider localeProvider;

  bool _isLoading = false;
  String? _errorMessage;

  List<FaqModel> _faqs = [];
  List<QuestionTopicModel> _topics = [];

  String? _selectedTopic;
  String? _searchQuery;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FaqModel> get faqs => _faqs;
  List<QuestionTopicModel> get topics => _topics;
  String? get selectedTopic => _selectedTopic;
  String? get searchQuery => _searchQuery;

  FaqProvider({
    required this.faqService,
    required this.inquiryService,
    required this.localeProvider,
  }) {
    localeProvider.addListener(_onLocaleChanged);
    init();
  }

  void _onLocaleChanged() {
    loadTopics();
    loadFaqs();
  }

  Future<void> init() async {
    await loadTopics();
    await loadFaqs();
  }

  Future<void> loadTopics() async {
    try {
      _topics = await inquiryService.getTopics();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadFaqs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _faqs = await faqService.getFaqs(
        topic: _selectedTopic,
        query: _searchQuery,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _faqs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTopic(String? topicSlug) {
    if (_selectedTopic == topicSlug) return;
    _selectedTopic = topicSlug;
    loadFaqs();
  }

  void setSearchQuery(String? query) {
    final clean = query?.trim();
    if (_searchQuery == clean) return;
    _searchQuery = (clean != null && clean.isNotEmpty) ? clean : null;
    loadFaqs();
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }
}

