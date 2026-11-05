import 'package:flutter/material.dart';
import '../core/localization/locale_provider.dart';
import '../models/category_model.dart';
import '../models/faq_model.dart';
import '../models/menu_model.dart';
import '../models/post_model.dart';
import '../models/question_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../services/faq_service.dart';
import '../services/inquiry_service.dart';
import '../services/page_service.dart';
import '../services/portal_service.dart';
import '../services/post_service.dart';

class PortalProvider extends ChangeNotifier {
  final PortalService portalService;
  final PostService postService;
  final PageService pageService;
  final FaqService faqService;
  final InquiryService inquiryService;
  final LocaleProvider localeProvider;

  bool _isLoading = false;
  String? _errorMessage;

  List<SlideModel> _slides = [];
  SettingModel? _settings;
  MenuModel? _headerMenu;
  MenuModel? _footerMenu;
  List<CategoryModel> _categories = [];
  List<PostModel> _featuredPosts = [];
  List<PostModel> _latestPosts = [];
  List<FaqModel> _faqsPreview = [];
  List<QuestionModel> _questionsPreview = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<SlideModel> get slides => _slides;
  SettingModel get settings =>
      _settings ?? SettingModel.fromJson({});
  MenuModel? get headerMenu => _headerMenu;
  MenuModel? get footerMenu => _footerMenu;
  List<CategoryModel> get categories => _categories;
  List<PostModel> get featuredPosts => _featuredPosts;
  List<PostModel> get latestPosts => _latestPosts;
  List<FaqModel> get faqsPreview => _faqsPreview;
  List<QuestionModel> get questionsPreview => _questionsPreview;

  PortalProvider({
    required this.portalService,
    required this.postService,
    required this.pageService,
    required this.faqService,
    required this.inquiryService,
    required this.localeProvider,
  }) {
    localeProvider.addListener(_onLocaleChanged);
    fetchHomeData();
  }

  void _onLocaleChanged() {
    // When user changes language, refresh all portal contents in the new language!
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        portalService.getSlides().catchError((_) => <SlideModel>[]),
        portalService.getSettings().catchError((_) => SettingModel.fromJson({})),
        portalService.getMenu('header').catchError((_) => null),
        portalService.getMenu('footer').catchError((_) => null),
        postService.getCategories().catchError((_) => <CategoryModel>[]),
        postService.getPosts(page: 1, perPage: 4, featured: true).catchError((_) => (posts: <PostModel>[], meta: null as dynamic)),
        postService.getPosts(page: 1, perPage: 6).catchError((_) => (posts: <PostModel>[], meta: null as dynamic)),
        faqService.getFaqs().catchError((_) => <FaqModel>[]),
        inquiryService.getQuestions(page: 1, perPage: 3).catchError((_) => (questions: <QuestionModel>[], meta: null as dynamic)),
      ]);

      _slides = results[0] as List<SlideModel>;
      _settings = results[1] as SettingModel;
      _headerMenu = results[2] as MenuModel?;
      _footerMenu = results[3] as MenuModel?;
      _categories = results[4] as List<CategoryModel>;

      final featuredResult = results[5] as dynamic;
      _featuredPosts = (featuredResult.posts as List<PostModel>);

      final latestResult = results[6] as dynamic;
      _latestPosts = (latestResult.posts as List<PostModel>);

      final faqs = results[7] as List<FaqModel>;
      _faqsPreview = faqs.take(5).toList();

      final questionsResult = results[8] as dynamic;
      _questionsPreview = (questionsResult.questions as List<QuestionModel>);

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }
}

