import 'package:flutter/material.dart';
import '../core/localization/locale_provider.dart';
import '../models/pagination_meta.dart';
import '../models/question_model.dart';
import '../models/question_topic_model.dart';
import '../services/inquiry_service.dart';

class InquiryProvider extends ChangeNotifier {
  final InquiryService inquiryService;
  final LocaleProvider localeProvider;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _submitError;
  bool _submitSuccess = false;

  List<QuestionModel> _questions = [];
  List<QuestionTopicModel> _topics = [];
  PaginationMeta _meta = PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: 10);

  String? _selectedTopic;
  String? _searchQuery;
  int _currentPage = 1;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get submitError => _submitError;
  bool get submitSuccess => _submitSuccess;

  List<QuestionModel> get questions => _questions;
  List<QuestionTopicModel> get topics => _topics;
  PaginationMeta get meta => _meta;
  String? get selectedTopic => _selectedTopic;
  String? get searchQuery => _searchQuery;
  int get currentPage => _currentPage;

  InquiryProvider({
    required this.inquiryService,
    required this.localeProvider,
  }) {
    localeProvider.addListener(_onLocaleChanged);
    init();
  }

  void _onLocaleChanged() {
    loadTopics();
    loadQuestions();
  }

  Future<void> init() async {
    await loadTopics();
    await loadQuestions();
  }

  Future<void> loadTopics() async {
    try {
      _topics = await inquiryService.getTopics();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await inquiryService.getQuestions(
        page: _currentPage,
        perPage: 10,
        topic: _selectedTopic,
        query: _searchQuery,
      );

      _questions = result.questions;
      _meta = result.meta;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTopic(String? topicSlug) {
    if (_selectedTopic == topicSlug) return;
    _selectedTopic = topicSlug;
    _currentPage = 1;
    loadQuestions();
  }

  void setSearchQuery(String? query) {
    final clean = query?.trim();
    if (_searchQuery == clean) return;
    _searchQuery = (clean != null && clean.isNotEmpty) ? clean : null;
    _currentPage = 1;
    loadQuestions();
  }

  void goToPage(int page) {
    if (page < 1 || page > _meta.lastPage || page == _currentPage) return;
    _currentPage = page;
    loadQuestions();
  }

  Future<bool> submitInquiry({
    required int topicId,
    required String name,
    required String email,
    String? phone,
    required String subject,
    required String body,
  }) async {
    _isSubmitting = true;
    _submitError = null;
    _submitSuccess = false;
    notifyListeners();

    try {
      await inquiryService.submitQuestion(
        topicId: topicId,
        name: name,
        email: email,
        phone: phone,
        subject: subject,
        body: body,
      );

      _submitSuccess = true;
      _submitError = null;
      return true;
    } catch (e) {
      _submitError = e.toString();
      _submitSuccess = false;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetSubmitState() {
    _submitSuccess = false;
    _submitError = null;
    _isSubmitting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }
}

