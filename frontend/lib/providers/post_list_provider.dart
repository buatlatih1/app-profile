import 'package:flutter/material.dart';
import '../core/localization/locale_provider.dart';
import '../models/category_model.dart';
import '../models/pagination_meta.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostListProvider extends ChangeNotifier {
  final PostService postService;
  final LocaleProvider localeProvider;

  bool _isLoading = false;
  String? _errorMessage;

  List<PostModel> _posts = [];
  List<CategoryModel> _categories = [];
  PaginationMeta _meta = PaginationMeta(currentPage: 1, lastPage: 1, total: 0, perPage: 9);

  String? _selectedCategory;
  String? _searchQuery;
  int _currentPage = 1;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PostModel> get posts => _posts;
  List<CategoryModel> get categories => _categories;
  PaginationMeta get meta => _meta;
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  int get currentPage => _currentPage;

  PostListProvider({
    required this.postService,
    required this.localeProvider,
  }) {
    localeProvider.addListener(_onLocaleChanged);
    init();
  }

  void _onLocaleChanged() {
    loadCategories();
    loadPosts();
  }

  Future<void> init() async {
    await loadCategories();
    await loadPosts();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await postService.getCategories();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await postService.getPosts(
        page: _currentPage,
        perPage: 9,
        category: _selectedCategory,
        query: _searchQuery,
      );

      _posts = result.posts;
      _meta = result.meta;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String? categorySlug) {
    if (_selectedCategory == categorySlug) return;
    _selectedCategory = categorySlug;
    _currentPage = 1;
    loadPosts();
  }

  void setSearchQuery(String? query) {
    final clean = query?.trim();
    if (_searchQuery == clean) return;
    _searchQuery = (clean != null && clean.isNotEmpty) ? clean : null;
    _currentPage = 1;
    loadPosts();
  }

  void goToPage(int page) {
    if (page < 1 || page > _meta.lastPage || page == _currentPage) return;
    _currentPage = page;
    loadPosts();
  }

  @override
  void dispose() {
    localeProvider.removeListener(_onLocaleChanged);
    super.dispose();
  }
}

