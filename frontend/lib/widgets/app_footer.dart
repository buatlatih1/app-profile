import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/portal_provider.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  void _openUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final portalProvider = context.watch<PortalProvider>();
    final settings = portalProvider.settings;
    final footerMenu = portalProvider.footerMenu;
    final isDesktop = Breakpoints.isDesktop(context);

    return Container(
      color: const Color(0xFF0F172A), // Slate-900
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: Breakpoints.contentMaxWidth(context)),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 20,
            vertical: 48,
          ),
          child: Column(
            children: [
              // Grid columns
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Col 1: About & Info
                    Expanded(
                      flex: 4,
                      child: _buildAgencyInfo(context, settings, l10n),
                    ),
                    const SizedBox(width: 48),

                    // Col 2: Navigation Links
                    Expanded(
                      flex: 3,
                      child: _buildNavigationLinks(context, footerMenu, l10n),
                    ),
                    const SizedBox(width: 48),

                    // Col 3: Contact & Hours
                    Expanded(
                      flex: 4,
                      child: _buildContactInfo(context, settings, l10n),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgencyInfo(context, settings, l10n),
                    const SizedBox(height: 36),
                    _buildNavigationLinks(context, footerMenu, l10n),
                    const SizedBox(height: 36),
                    _buildContactInfo(context, settings, l10n),
                  ],
                ),

              const SizedBox(height: 48),
              const Divider(color: Color(0xFF334155), height: 1),
              const SizedBox(height: 24),

              // Bottom Bar: Copyright & Socials
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '© ${DateTime.now().year} ${settings.siteName}. ${l10n.text('footer_rights')}',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (settings.socialMedia.isNotEmpty)
                    Row(
                      children: settings.socialMedia.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            icon: _getSocialIcon(entry.key),
                            color: const Color(0xFF94A3B8),
                            iconSize: 18,
                            tooltip: entry.key,
                            onPressed: () => _openUrl(entry.value),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgencyInfo(BuildContext context, dynamic settings, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                settings.siteName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          settings.siteTagline.isNotEmpty
              ? settings.siteTagline
              : l10n.text('hero_tag'),
          style: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        if (settings.siteDescription.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            settings.siteDescription,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavigationLinks(BuildContext context, dynamic footerMenu, AppLocalizations l10n) {
    final List<Map<String, String>> fallbackLinks = [
      {'label': l10n.text('nav_home'), 'url': '/'},
      {'label': l10n.text('nav_posts'), 'url': '/posts'},
      {'label': l10n.text('nav_questions'), 'url': '/questions'},
      {'label': l10n.text('nav_faqs'), 'url': '/faqs'},
      {'label': l10n.text('nav_ask_question'), 'url': '/questions/new'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.text('footer_navigation'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        if (footerMenu != null && footerMenu.items.isNotEmpty)
          ...footerMenu.items.map<Widget>((item) {
            return _buildFooterLink(
              label: item.label,
              onTap: () {
                if (item.url.startsWith('/')) {
                  context.go(item.url);
                } else {
                  _openUrl(item.url);
                }
              },
            );
          }).toList()
        else
          ...fallbackLinks.map((link) {
            return _buildFooterLink(
              label: link['label']!,
              onTap: () => context.go(link['url']!),
            );
          }),
      ],
    );
  }

  Widget _buildFooterLink({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_right_rounded, size: 14, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, dynamic settings, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.text('footer_contact'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(Icons.location_on_outlined, settings.address),
        const SizedBox(height: 10),
        _buildContactItem(Icons.phone_outlined, settings.phone),
        const SizedBox(height: 10),
        _buildContactItem(Icons.email_outlined, settings.email),
        const SizedBox(height: 10),
        _buildContactItem(Icons.access_time_rounded, settings.officeHours),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Icon(Icons.facebook_rounded);
      case 'instagram':
        return const Icon(Icons.camera_alt_outlined);
      case 'twitter':
      case 'x':
        return const Icon(Icons.tag_rounded);
      case 'youtube':
        return const Icon(Icons.play_circle_fill_rounded);
      default:
        return const Icon(Icons.link_rounded);
    }
  }
}

