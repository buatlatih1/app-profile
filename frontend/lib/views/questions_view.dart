import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/inquiry_provider.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/question_card.dart';

class QuestionsView extends StatefulWidget {
  final String? initialTopic;
  final String? initialQuery;

  const QuestionsView({
    super.key,
    this.initialTopic,
    this.initialQuery,
  });

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InquiryProvider>();
      if (widget.initialTopic != null) {
        provider.setTopic(widget.initialTopic);
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
    final provider = context.watch<InquiryProvider>();
    final isDesktop = Breakpoints.isDesktop(context);
    final maxW = Breakpoints.contentMaxWidth(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxW),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 36,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with CTA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.text('questions_title'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.text('questions_subtitle'),
                      style: const TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: () => context.go('/questions/new'),
                  icon: const Icon(Icons.add_comment_rounded, size: 18),
                  label: Text(
                    l10n.text('submit_question_btn'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),

          if (!isDesktop) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => context.go('/questions/new'),
                icon: const Icon(Icons.add_comment_rounded, size: 18),
                label: Text(l10n.text('submit_question_btn')),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Search Bar & Topic Chips
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
                onRetry: () => provider.loadQuestions(),
              ),
            )
          else if (provider.questions.isEmpty)
            _buildEmptyState(context, l10n)
          else ...[
            ...provider.questions.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: QuestionCard(question: question),
              );
            }),

            const SizedBox(height: 32),

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
    InquiryProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.text('search_questions_hint'),
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTopicChip(
                label: l10n.text('all_topics'),
                isSelected: provider.selectedTopic == null,
                onTap: () => provider.setTopic(null),
              ),
              const SizedBox(width: 8),
              ...provider.topics.map((topic) {
                final isSelected = provider.selectedTopic == topic.slug;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildTopicChip(
                    label: topic.name,
                    isSelected: isSelected,
                    onTap: () => provider.setTopic(topic.slug),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopicChip({
    required String label,
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textMain,
          ),
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
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade400),
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
    InquiryProvider provider,
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

