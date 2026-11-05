import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../models/page_model.dart';
import '../services/page_service.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_indicator.dart';

class PageDetailView extends StatefulWidget {
  final String slug;

  const PageDetailView({super.key, required this.slug});

  @override
  State<PageDetailView> createState() => _PageDetailViewState();
}

class _PageDetailViewState extends State<PageDetailView> {
  PageModel? _page;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  @override
  void didUpdateWidget(covariant PageDetailView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pageService = context.read<PageService>();
      final page = await pageService.getPageBySlug(widget.slug);
      setState(() {
        _page = page;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = Breakpoints.isDesktop(context);
    final maxW = Breakpoints.contentMaxWidth(context);

    if (_isLoading) {
      return const SizedBox(height: 500, child: LoadingIndicator());
    }

    if (_errorMessage != null || _page == null) {
      return SizedBox(
        height: 500,
        child: ErrorDisplay(
          message: _errorMessage ?? l10n.text('page_not_found_desc'),
          onRetry: _fetchPage,
        ),
      );
    }

    final page = _page!;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: isDesktop ? 860 : maxW),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back navigation
            InkWell(
              onTap: () => context.go('/'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_rounded, size: 18, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.text('back_to_home'),
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
            const SizedBox(height: 20),

            // Page Title
            Text(
              page.title,
              style: TextStyle(
                fontSize: isDesktop ? 34 : 26,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),

            // Optional Image
            if (page.resolvedImageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  page.resolvedImageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Content
            if (page.content != null && page.content!.isNotEmpty)
              HtmlWidget(
                page.content!,
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
          ],
        ),
      ),
    );
  }
}

