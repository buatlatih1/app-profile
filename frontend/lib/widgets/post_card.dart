import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isHorizontal;

  const PostCard({
    super.key,
    required this.post,
    this.isHorizontal = false,
  });

  String _formatDate(DateTime? dt, String lang) {
    if (dt == null) return '';
    try {
      final formatter = DateFormat('dd MMM yyyy', lang == 'en' ? 'en_US' : 'id_ID');
      return formatter.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = l10n.locale.languageCode;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/posts/${post.slug}'),
        child: isHorizontal
            ? _buildHorizontalLayout(context, l10n, lang)
            : _buildVerticalLayout(context, l10n, lang),
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, AppLocalizations l10n, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Header
        _buildImage(height: 180),

        // Body
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category & Views
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (post.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        post.category!.name,
                        style: const TextStyle(
                          color: AppTheme.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      const Icon(Icons.visibility_outlined, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${post.viewCount}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),

              // Summary
              if (post.summary != null && post.summary!.isNotEmpty)
                Text(
                  post.summary!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    height: 1.45,
                  ),
                ),
              const SizedBox(height: 16),

              // Footer Meta
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: AppTheme.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(post.publishedAt ?? post.createdAt, lang),
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const Spacer(),
                  Text(
                    l10n.text('read_more'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.primary),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, AppLocalizations l10n, String lang) {
    return SizedBox(
      height: 140,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: double.infinity,
            child: _buildImage(height: 140),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.category != null)
                        Text(
                          post.category!.name.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(post.publishedAt ?? post.createdAt, lang),
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 13, color: AppTheme.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${post.viewCount}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage({required double height}) {
    final imgUrl = post.resolvedImageUrl;

    if (imgUrl != null && imgUrl.isNotEmpty) {
      return Image.network(
        imgUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(height),
      );
    }
    return _buildPlaceholder(height);
  }

  Widget _buildPlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFE2E8F0),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Colors.slate.shade400,
        ),
      ),
    );
  }
}

extension on Colors {
  static Color get slate => const Color(0xFF94A3B8);
}

