import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_indicator.dart';

class PostDetailView extends StatefulWidget {
  final String slug;

  const PostDetailView({super.key, required this.slug});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  PostModel? _post;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  @override
  void didUpdateWidget(covariant PostDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final postService = context.read<PostService>();
      final post = await postService.getPostBySlug(widget.slug);
      setState(() {
        _post = post;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? dt, String lang) {
    if (dt == null) return '';
    try {
      final formatter = DateFormat('EEEE, dd MMMM yyyy • HH:mm', lang == 'en' ? 'en_US' : 'id_ID');
      return formatter.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  void _sharePost(AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: Uri.base.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.text('share_copied')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.locale.languageCode;
    final isDesktop = Breakpoints.isDesktop(context);
    final maxW = Breakpoints.contentMaxWidth(context);

    if (_isLoading) {
      return const SizedBox(height: 500, child: LoadingIndicator());
    }

    if (_errorMessage != null || _post == null) {
      return SizedBox(
        height: 500,
        child: ErrorDisplay(
          message: _errorMessage ?? l10n.text('no_data'),
          onRetry: _fetchDetail,
        ),
      );
    }

    final post = _post!;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: isDesktop ? 860 : maxW),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            InkWell(
              onTap: () => context.go('/posts'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_rounded, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.text('back'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category & Featured
            Row(
              children: [
                if (post.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      post.category!.name,
                      style: const TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (post.isFeatured) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: Colors.amber.shade900),
                        const SizedBox(width: 4),
                        Text(
                          l10n.locale.languageCode == 'en' ? 'Featured' : 'Utama',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Post Title
            Text(
              post.title,
              style: TextStyle(
                fontSize: isDesktop ? 32 : 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 18),

            // Meta row: Author, Date, Views, Share
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.border),
                  bottom: BorderSide(color: AppTheme.border),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      post.author?.name.characters.firstOrNull?.toUpperCase() ?? 'A',
                      style: const TextStyle(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author?.name ?? 'Admin Portal',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMain,
                          ),
                        ),
                        Text(
                          _formatDate(post.publishedAt ?? post.createdAt, lang),
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.visibility_outlined, size: 15, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${post.viewCount} ${l10n.text('views')}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18, color: AppTheme.textMuted),
                    tooltip: l10n.text('share'),
                    onPressed: () => _sharePost(l10n),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Featured Image
            if (post.resolvedImageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  post.resolvedImageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Summary Callout Box
            if (post.summary != null && post.summary!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Slate-100
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(color: AppTheme.primary, width: 4),
                  ),
                ),
                child: Text(
                  post.summary!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF334155),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Rich HTML Content
            if (post.content != null && post.content!.isNotEmpty)
              HtmlWidget(
                post.content!,
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: Color(0xFF1E293B),
                ),
                customStylesBuilder: (element) {
                  if (element.localName == 'p') {
                    return {'margin-bottom': '16px'};
                  }
                  if (element.localName == 'h2') {
                    return {'font-size': '22px', 'font-weight': 'bold', 'margin-top': '24px', 'margin-bottom': '12px'};
                  }
                  if (element.localName == 'h3') {
                    return {'font-size': '18px', 'font-weight': 'bold', 'margin-top': '20px', 'margin-bottom': '10px'};
                  }
                  return null;
                },
              ),

            const SizedBox(height: 48),
            const Divider(color: AppTheme.border),
            const SizedBox(height: 20),

            // Footer navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.go('/posts'),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(l10n.text('view_all')),
                ),
                ElevatedButton.icon(
                  onPressed: () => _sharePost(l10n),
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: Text(l10n.text('share')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

