import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/portal_provider.dart';
import '../widgets/error_display.dart';
import '../widgets/faq_accordion.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/post_card.dart';
import '../widgets/question_card.dart';
import '../widgets/slide_carousel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final portalProvider = context.watch<PortalProvider>();
    final isDesktop = Breakpoints.isDesktop(context);
    final maxW = Breakpoints.contentMaxWidth(context);

    if (portalProvider.isLoading && portalProvider.slides.isEmpty) {
      return const SizedBox(
        height: 600,
        child: LoadingIndicator(),
      );
    }

    if (portalProvider.errorMessage != null && portalProvider.slides.isEmpty) {
      return SizedBox(
        height: 600,
        child: ErrorDisplay(
          message: portalProvider.errorMessage,
          onRetry: () => portalProvider.fetchHomeData(),
        ),
      );
    }

    return Column(
      children: [
        // 1. Hero Slide Carousel
        SlideCarousel(slides: portalProvider.slides),

        // 2. Quick Feature Highlights Bar
        _buildHighlightsBar(context, maxW, isDesktop, l10n),

        // 3. Featured Posts / Berita Utama
        if (portalProvider.featuredPosts.isNotEmpty)
          _buildFeaturedSection(context, portalProvider, maxW, isDesktop, l10n),

        // 4. Categories Carousel / Pills
        if (portalProvider.categories.isNotEmpty)
          _buildCategoriesSection(context, portalProvider, maxW, isDesktop, l10n),

        // 5. Latest Posts / Berita Terkini
        _buildLatestPostsSection(context, portalProvider, maxW, isDesktop, l10n),

        // 6. Citizen Inquiry CTA & Recent Questions Preview
        _buildCitizenInquirySection(context, portalProvider, maxW, isDesktop, l10n),

        // 7. FAQ Preview Section
        if (portalProvider.faqsPreview.isNotEmpty)
          _buildFaqSection(context, portalProvider, maxW, isDesktop, l10n),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHighlightsBar(
    BuildContext context,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    final items = [
      {
        'icon': Icons.public_rounded,
        'title': l10n.locale.languageCode == 'en' ? 'Open & Transparent' : 'Keterbukaan Informasi',
        'desc': l10n.locale.languageCode == 'en' ? 'Accessible public service data' : 'Akses informasi publik secara terbuka & akuntabel',
      },
      {
        'icon': Icons.flash_on_rounded,
        'title': l10n.locale.languageCode == 'en' ? 'Responsive Service' : 'Pelayanan Cepat',
        'desc': l10n.locale.languageCode == 'en' ? 'Fast responses to inquiries' : 'Tanggapan terpadu dan tanggap dari petugas',
      },
      {
        'icon': Icons.forum_rounded,
        'title': l10n.locale.languageCode == 'en' ? 'Citizen Inquiries' : 'Aspirasi & Pengaduan',
        'desc': l10n.locale.languageCode == 'en' ? 'Two-way official communication' : 'Saluran komunikasi dua arah masyarakat resmi',
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isDesktop
              ? Row(
                  children: items.map((item) {
                    return Expanded(
                      child: _buildHighlightItem(
                        item['icon'] as IconData,
                        item['title'] as String,
                        item['desc'] as String,
                      ),
                    );
                  }).toList(),
                )
              : Column(
                  children: items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildHighlightItem(
                        item['icon'] as IconData,
                        item['title'] as String,
                        item['desc'] as String,
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String title, String desc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(
    BuildContext context,
    PortalProvider provider,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                context,
                title: l10n.text('featured_posts'),
                subtitle: l10n.locale.languageCode == 'en'
                    ? 'Highlighted official information and priority news'
                    : 'Publikasi dan informasi prioritas dari instansi',
                onViewAll: () => context.go('/posts?featured=1'),
                l10n: l10n,
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final colCount = isDesktop ? 3 : (constraints.maxWidth > 580 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.featuredPosts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isDesktop ? 0.82 : 0.88,
                    ),
                    itemBuilder: (context, index) {
                      return PostCard(post: provider.featuredPosts[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    PortalProvider provider,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.locale.languageCode == 'en' ? 'Browse by Category' : 'Jelajahi Berdasarkan Kategori',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: provider.categories.map((cat) {
                  return InkWell(
                    onTap: () => context.go('/posts?category=${cat.slug}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_outlined, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            cat.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMain,
                            ),
                          ),
                          if (cat.postsCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${cat.postsCount}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestPostsSection(
    BuildContext context,
    PortalProvider provider,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                context,
                title: l10n.text('latest_posts'),
                subtitle: l10n.locale.languageCode == 'en'
                    ? 'Latest news, official notices, and activity updates'
                    : 'Kabar terkini seputar kebijakan dan kegiatan pelayanan',
                onViewAll: () => context.go('/posts'),
                l10n: l10n,
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final colCount = isDesktop ? 3 : (constraints.maxWidth > 580 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.latestPosts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isDesktop ? 0.82 : 0.88,
                    ),
                    itemBuilder: (context, index) {
                      return PostCard(post: provider.latestPosts[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCitizenInquirySection(
    BuildContext context,
    PortalProvider provider,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    return Container(
      color: const Color(0xFFF1F5F9), // Slate-100
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // CTA Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 20,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F766E).withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.text('inquiry_cta_title'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.text('inquiry_cta_desc'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryDark,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            onPressed: () => context.go('/questions/new'),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: Text(
                              l10n.text('inquiry_cta_btn'),
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('inquiry_cta_title'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.text('inquiry_cta_desc'),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryDark,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                            onPressed: () => context.go('/questions/new'),
                            icon: const Icon(Icons.send_rounded, size: 18),
                            label: Text(l10n.text('inquiry_cta_btn')),
                          ),
                        ],
                      ),
              ),

              // Recent Questions Preview
              if (provider.questionsPreview.isNotEmpty) ...[
                const SizedBox(height: 40),
                _buildSectionHeader(
                  context,
                  title: l10n.locale.languageCode == 'en'
                      ? 'Answered Public Inquiries'
                      : 'Pertanyaan Publik yang Telah Dijawab',
                  subtitle: l10n.locale.languageCode == 'en'
                      ? 'Verified answers provided by official service teams'
                      : 'Transparansi jawaban resmi terhadap aspirasi warga',
                  onViewAll: () => context.go('/questions'),
                  l10n: l10n,
                ),
                const SizedBox(height: 20),
                ...provider.questionsPreview.map((q) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: QuestionCard(question: q),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection(
    BuildContext context,
    PortalProvider provider,
    double maxW,
    bool isDesktop,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxW),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                context,
                title: l10n.text('faqs_title'),
                subtitle: l10n.text('faqs_subtitle'),
                onViewAll: () => context.go('/faqs'),
                l10n: l10n,
              ),
              const SizedBox(height: 20),
              ...provider.faqsPreview.map((faq) {
                return FaqAccordion(faq: faq);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onViewAll,
    required AppLocalizations l10n,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onViewAll,
          icon: Text(
            l10n.text('view_all'),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          label: const Icon(Icons.arrow_forward_rounded, size: 16),
        ),
      ],
    );
  }
}

