import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/portal_provider.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppNavbar({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDesktop = Breakpoints.isDesktop(context);
    final portalProvider = context.watch<PortalProvider>();
    final settings = portalProvider.settings;
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: Breakpoints.contentMaxWidth(context)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 74,
            child: Row(
              children: [
                // Mobile Drawer button
                if (!isDesktop) ...[
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, color: AppTheme.textMain, size: 26),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 8),
                ],

                // Logo & Title
                InkWell(
                  onTap: () => context.go('/'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (settings.resolvedLogoUrl != null)
                          Image.network(
                            settings.resolvedLogoUrl!,
                            height: 38,
                            width: 38,
                            errorBuilder: (_, __, ___) => _buildLogoIcon(),
                          )
                        else
                          _buildLogoIcon(),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.siteName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryDark,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (isDesktop && settings.siteTagline.isNotEmpty)
                              Text(
                                settings.siteTagline,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Desktop Navigation Links
                if (isDesktop) ...[
                  _buildNavLink(context, l10n.text('nav_home'), '/', currentRoute == '/'),
                  _buildNavLink(context, l10n.text('nav_posts'), '/posts', currentRoute.startsWith('/posts')),
                  _buildNavLink(context, l10n.text('nav_questions'), '/questions', currentRoute.startsWith('/questions')),
                  _buildNavLink(context, l10n.text('nav_faqs'), '/faqs', currentRoute.startsWith('/faqs')),
                  const SizedBox(width: 12),
                ],

                // Language Switcher
                _buildLanguageSelector(context),

                const SizedBox(width: 12),

                // Submit Question CTA Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 16 : 12,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => context.go('/questions/new'),
                  icon: const Icon(Icons.add_comment_rounded, size: 16),
                  label: Text(
                    isDesktop ? l10n.text('nav_ask_question') : l10n.text('nav_ask_question').split(' ').first,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.account_balance_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildNavLink(BuildContext context, String title, String route, bool isActive) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: isActive ? AppTheme.primaryDark : AppTheme.secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentCode = localeProvider.languageCode;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Slate-100
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangChip(
            label: 'ID',
            isActive: currentCode == 'id',
            onTap: () => localeProvider.setLocale(const Locale('id')),
          ),
          _buildLangChip(
            label: 'EN',
            isActive: currentCode == 'en',
            onTap: () => localeProvider.setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildLangChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

