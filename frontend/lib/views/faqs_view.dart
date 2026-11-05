import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/faq_provider.dart';
import '../widgets/error_display.dart';
import '../widgets/faq_accordion.dart';
import '../widgets/loading_indicator.dart';

class FaqsView extends StatefulWidget {
  final String? initialTopic;
  final String? initialQuery;

  const FaqsView({
    super.key,
    this.initialTopic,
    this.initialQuery,
  });

  @override
  State<FaqsView> createState() => _FaqsViewState();
}

class _FaqsViewState extends State<FaqsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FaqProvider>();
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
    final provider = context.watch<FaqProvider>();
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
          // Header
          Text(
            l10n.text('faqs_title'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.text('faqs_subtitle'),
            style: const TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
          ),
          const SizedBox(height: 28),

          // Search & Topic Filters
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
                onRetry: () => provider.loadFaqs(),
              ),
            )
          else if (provider.faqs.isEmpty)
            _buildEmptyState(context, l10n)
          else ...[
            ...provider.faqs.map((faq) {
              return FaqAccordion(faq: faq);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    FaqProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.text('search_faqs_hint'),
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
            Icon(Icons.help_center_outlined, size: 64, color: Colors.grey.shade400),
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
}

