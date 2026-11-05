import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/post_list_provider.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_card.dart';

class PostsView extends StatefulWidget {
  final String? initialCategory;
  final String? initialQuery;

  const PostsView({
    super.key,
    this.initialCategory,
    this.initialQuery,
  });

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PostListProvider>();
      if (widget.initialCategory != null) {
        provider.setCategory(widget.initialCategory);
      }
      if (widget.initialQuery != null) {
        provider.setSearchQuery(widget.initialQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<PostListProvider>();
    final isDesktop = Breakpoints.isDesktop(context);
    final maxW = Breakpoints.contentMaxWidth(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxW),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.text('nav_posts'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.locale.languageCode == 'en'
                ? 'Official publications, announcements, and press releases'
                : 'Pusat publikasi berita, pengumuman, dan siaran pers resmi',
            style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),

          // Search Bar & Filter Controls
          _buildSearchAndFilters(context, provider, l10n),
          const SizedBox(height: 28),

          // Content
          if (provider.isLoading)
            const SizedBox(height: 400, child: LoadingIndicator())
          else if (provider.errorMessage != null)
            SizedBox(
              height: 400,
              child: ErrorDisplay(
                message: provider.errorMessage,
                onRetry: () => provider.loadPosts(),
              ),
            )
          else if (provider.posts.isEmpty)
            _buildEmptyState(context, l10n)
          else ...[
            // Posts Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final colCount = isDesktop ? 3 : (constraints.maxWidth > 580 ? 2 : 1);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: colCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isDesktop ? 0.82 : 0.88,
                  ),
                  itemBuilder: (context, index) {
                    return PostCard(post: provider.posts[index]);
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            // Pagination Controls
            if (provider.meta.lastPage > 1)
              _buildPagination(context, provider, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    PostListProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search TextField
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.text('search_posts_hint'),
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery(null);
                    },
                  )
                : null,
          ),
          onSubmitted: (value) => provider.setSearchQuery(value),
        ),
        const SizedBox(height: 16),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // All Categories Chip
              _buildCategoryChip(
                label: l10n.text('all_categories'),
                isSelected: provider.selectedCategory == null,
                onTap: () => provider.setCategory(null),
              ),
              const SizedBox(width: 8),

              // Dynamic Categories
              ...provider.categories.map((cat) {
                final isSelected = provider.selectedCategory == cat.slug;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildCategoryChip(
                    label: cat.name,
                    count: cat.postsCount > 0 ? cat.postsCount : null,
                    isSelected: isSelected,
                    onTap: () => provider.setCategory(cat.slug),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textMain,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.feed_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              l10n.text('no_data'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(
    BuildContext context,
    PostListProvider provider,
    AppLocalizations l10n,
  ) {
    final meta = provider.meta;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: meta.hasPrevPage
              ? () => provider.goToPage(meta.currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left_rounded, size: 18),
          label: Text(l10n.text('pagination_prev')),
        ),
        const SizedBox(width: 16),
        Text(
          '${l10n.text('pagination_page')} ${meta.currentPage} ${l10n.text('pagination_of')} ${meta.lastPage}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: meta.hasNextPage
              ? () => provider.goToPage(meta.currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right_rounded, size: 18),
          label: Text(l10n.text('pagination_next')),
        ),
      ],
    );
  }
}

